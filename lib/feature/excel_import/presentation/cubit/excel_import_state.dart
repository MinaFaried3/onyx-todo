import 'package:onyx_todo/core/controller/cubit/base_state.dart';
import 'package:onyx_todo/core/controller/cubit/sub_state.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';

final class ExcelImportState extends BaseState {
  final SubState<int> importState;
  final String? fileName;
  final List<TaskEntity> previewTasks;
  final List<String> sheetsFound;

  const ExcelImportState({
    super.uiState,
    super.failure,
    this.importState = const SubState(),
    this.fileName,
    this.previewTasks = const [],
    this.sheetsFound = const [],
  });

  @override
  List<Object?> get props => [
        uiState,
        failure,
        importState,
        fileName,
        previewTasks,
        sheetsFound,
      ];

  @override
  ExcelImportState copyWith({
    UiState? uiState,
    Failure? Function()? failure,
    SubState<int>? importState,
    String? Function()? fileName,
    List<TaskEntity>? previewTasks,
    List<String>? sheetsFound,
  }) {
    return ExcelImportState(
      uiState: uiState ?? this.uiState,
      failure: failure != null ? failure.copy : this.failure,
      importState: importState ?? this.importState,
      fileName: fileName != null ? fileName() : this.fileName,
      previewTasks: previewTasks ?? this.previewTasks,
      sheetsFound: sheetsFound ?? this.sheetsFound,
    );
  }
}
