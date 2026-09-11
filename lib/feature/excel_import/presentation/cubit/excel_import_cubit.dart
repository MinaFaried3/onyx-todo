import 'dart:typed_data';
import 'package:onyx_todo/core/controller/cubit/base_cubit.dart';
import 'package:onyx_todo/core/controller/cubit/sub_state.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/feature/excel_import/data/services/excel_parser_service.dart';
import 'package:onyx_todo/feature/excel_import/presentation/cubit/excel_import_state.dart';
import 'package:onyx_todo/feature/task/domain/repositories/task_repository.dart';

class ExcelImportCubit extends BaseCubit<ExcelImportState> {
  final ExcelParserService _excelParserService;
  final TaskRepository _taskRepository;

  ExcelImportCubit({
    required ExcelParserService excelParserService,
    required TaskRepository taskRepository,
  })  : _excelParserService = excelParserService,
        _taskRepository = taskRepository,
        super(const ExcelImportState());

  Future<void> processExcelBytes(Uint8List bytes, String fileName) async {
    emit(state.copyWith(
      importState: state.importState.copyWith(state: UiState.loading),
      fileName: () => fileName,
    ));

    try {
      final tasks = _excelParserService.parseExcelBytes(bytes);
      final sheets = tasks.map((t) => t.moduleCode).toSet().toList()..sort();

      emit(state.copyWith(
        previewTasks: tasks,
        sheetsFound: sheets,
      ));

      // Batch import parsed tasks to repository
      final res = await _taskRepository.importTasks(tasks);

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
