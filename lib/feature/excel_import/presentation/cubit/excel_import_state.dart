import 'package:onyx_todo/core/controller/cubit/base_state.dart';
import 'package:onyx_todo/core/controller/cubit/sub_state.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';

final class ExcelImportState extends BaseState {
  final SubState<int> parseState;
  final SubState<int> importState;
  final String? fileName;
  final List<TaskEntity> previewTasks;
  final List<String> sheetsFound;
  final double uploadProgress;
  final int uploadedCount;
  final int totalToUpload;
  final String selectedPreviewModule; // 'ALL' or specific sheet code

  const ExcelImportState({
    super.uiState,
    super.failure,
    this.parseState = const SubState(),
    this.importState = const SubState(),
    this.fileName,
    this.previewTasks = const [],
    this.sheetsFound = const [],
    this.uploadProgress = 0.0,
    this.uploadedCount = 0,
    this.totalToUpload = 0,
    this.selectedPreviewModule = 'ALL',
  });

  bool get isStaged => previewTasks.isNotEmpty && !importState.isSucceed;

  List<TaskEntity> get filteredPreviewTasks {
    if (selectedPreviewModule == 'ALL' || selectedPreviewModule.isEmpty) {
      return previewTasks;
    }
    return previewTasks
        .where((t) => t.moduleCode.toUpperCase() == selectedPreviewModule.toUpperCase())
        .toList();
  }

  @override
  List<Object?> get props => [
        uiState,
        failure,
        parseState,
        importState,
        fileName,
        previewTasks,
        sheetsFound,
        uploadProgress,
        uploadedCount,
        totalToUpload,
        selectedPreviewModule,
      ];

  @override
  ExcelImportState copyWith({
    UiState? uiState,
    Failure? Function()? failure,
    SubState<int>? parseState,
    SubState<int>? importState,
    String? Function()? fileName,
    List<TaskEntity>? previewTasks,
    List<String>? sheetsFound,
    double? uploadProgress,
    int? uploadedCount,
    int? totalToUpload,
    String? selectedPreviewModule,
  }) {
    return ExcelImportState(
      uiState: uiState ?? this.uiState,
      failure: failure != null ? failure.copy : this.failure,
      parseState: parseState ?? this.parseState,
      importState: importState ?? this.importState,
      fileName: fileName != null ? fileName() : this.fileName,
      previewTasks: previewTasks ?? this.previewTasks,
      sheetsFound: sheetsFound ?? this.sheetsFound,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      uploadedCount: uploadedCount ?? this.uploadedCount,
      totalToUpload: totalToUpload ?? this.totalToUpload,
      selectedPreviewModule: selectedPreviewModule ?? this.selectedPreviewModule,
    );
  }
}
