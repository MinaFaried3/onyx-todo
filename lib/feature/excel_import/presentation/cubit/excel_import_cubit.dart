import 'dart:typed_data';
import 'package:onyx_todo/core/controller/cubit/base_cubit.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/feature/excel_import/data/services/excel_parser_service.dart';
import 'package:onyx_todo/feature/excel_import/presentation/cubit/excel_import_state.dart';
import 'package:onyx_todo/feature/task/domain/repositories/task_repository.dart';

class ExcelImportCubit extends BaseCubit<ExcelImportState> {
  final ExcelParserService excelParserService;
  final TaskRepository taskRepository;

  ExcelImportCubit({
    required this.excelParserService,
    required this.taskRepository,
  }) : super(const ExcelImportState());

  /// Step 1: Parse Excel bytes into staged preview tasks (In-Memory Only).
  /// Does NOT write to Firestore or the main task repository.
  Future<void> processExcelBytes(Uint8List bytes, String fileName) async {
    Printer.log('ExcelImportCubit: Parsing $fileName (${bytes.length} bytes) into staged preview');
    emit(state.copyWith(
      parseState: state.parseState.copyWith(state: UiState.loading),
      fileName: () => fileName,
    ));

    try {
      final tasks = await excelParserService.parseExcelBytes(bytes);
      final sheets = tasks.map((t) => t.moduleCode).toSet().toList()..sort();

      Printer.log('ExcelImportCubit: Staged ${tasks.length} tasks across ${sheets.length} sheets for review');

      emit(state.copyWith(
        previewTasks: tasks,
        sheetsFound: sheets,
        totalToUpload: tasks.length,
        uploadedCount: 0,
        uploadProgress: 0.0,
        parseState: state.parseState.copyWith(
          state: UiState.succeed,
          data: tasks.length,
        ),
        selectedPreviewModule: 'ALL',
      ));
    } catch (e, st) {
      Printer.log('ExcelImportCubit parse error: $e\n$st');
      emit(state.copyWith(
        parseState: state.parseState.copyWith(
          state: UiState.failed,
          message: e.toString(),
        ),
      ));
    }
  }

  void filterPreviewByModule(String moduleCode) {
    emit(state.copyWith(selectedPreviewModule: moduleCode));
  }

  /// Step 2: Explicitly upload staged tasks to Cloud Firestore with live progress reporting.
  Future<void> confirmImport() async {
    if (state.previewTasks.isEmpty) return;

    Printer.log('ExcelImportCubit: Starting Cloud Firestore upload for ${state.previewTasks.length} tasks');
    emit(state.copyWith(
      importState: state.importState.copyWith(state: UiState.loading),
      uploadProgress: 0.0,
      uploadedCount: 0,
    ));

    try {
      final res = await taskRepository.importTasks(
        state.previewTasks,
        onProgress: (uploaded, total) {
          final progress = total > 0 ? (uploaded / total) : 1.0;
          emit(state.copyWith(
            uploadedCount: uploaded,
            totalToUpload: total,
            uploadProgress: progress,
          ));
        },
      );

      res.fold(
        (failure) {
          Printer.log('ExcelImportCubit: Task import failed - ${failure.message}');
          emit(state.copyWith(
            importState: state.importState.copyWith(
              state: UiState.failed,
              failure: () => failure,
              message: failure.message,
            ),
          ));
        },
        (count) {
          Printer.log('ExcelImportCubit: Successfully imported $count tasks to repository');
          emit(state.copyWith(
            importState: state.importState.copyWith(
              state: UiState.succeed,
              data: count,
            ),
            uploadProgress: 1.0,
            uploadedCount: count,
          ));
        },
      );
    } catch (e, st) {
      Printer.log('ExcelImportCubit confirmImport error: $e\n$st');
      emit(state.copyWith(
        importState: state.importState.copyWith(
          state: UiState.failed,
          message: e.toString(),
        ),
      ));
    }
  }

  void discardStagedImport() {
    emit(const ExcelImportState());
  }

  void reset() {
    emit(const ExcelImportState());
  }
}
