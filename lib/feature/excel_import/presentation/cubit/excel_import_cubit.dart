import 'dart:typed_data';
import 'package:onyx_todo/core/controller/cubit/base_cubit.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
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

  Future<void> processExcelBytes(Uint8List bytes, String fileName) async {
    emit(state.copyWith(
      importState: state.importState.copyWith(state: UiState.loading),
      fileName: () => fileName,
    ));

    try {
      final tasks = excelParserService.parseExcelBytes(bytes);
      final sheets = tasks.map((t) => t.moduleCode).toSet().toList()..sort();

      emit(state.copyWith(
        previewTasks: tasks,
        sheetsFound: sheets,
      ));

      // Batch import parsed tasks to repository
      final res = await taskRepository.importTasks(tasks);

      res.fold(
        (failure) => emit(state.copyWith(
          importState: state.importState.copyWith(
            state: UiState.failed,
            failure: () => failure,
          ),
        )),
        (count) => emit(state.copyWith(
          importState: state.importState.copyWith(
            state: UiState.succeed,
            data: count,
          ),
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        importState: state.importState.copyWith(
          state: UiState.failed,
          message: e.toString(),
        ),
      ));
    }
  }

  void reset() {
    emit(const ExcelImportState());
  }
}
