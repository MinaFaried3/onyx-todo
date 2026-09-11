import 'package:onyx_todo/core/controller/cubit/base_state.dart';
import 'package:onyx_todo/core/controller/cubit/sub_state.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/auth/domain/entities/user_profile.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/onyx_module.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/onyx_version.dart';

enum WorkspaceView {
  list,
  board,
  workload,
  analytics,
  achievements,
  monthlyPlan,
  excelImport,
}

final class WorkspaceState extends BaseState {
  final SubState<List<OnyxModule>> modulesState;
  final SubState<List<OnyxVersion>> versionsState;
  final String selectedModuleCode; // 'ALL' or specific module code
  final String selectedVersionCode; // 'ALL' or specific version e.g. 'V5.1.8'
  final WorkspaceView activeView;
  final bool isSidebarCollapsed;
  final UserProfile currentUser;
  final List<UserProfile> availableUsers;

  const WorkspaceState({
    super.uiState,
    super.failure,
    this.modulesState = const SubState(),
    this.versionsState = const SubState(),
    this.selectedModuleCode = 'ALL',
    this.selectedVersionCode = 'V5.1.8',
    this.activeView = WorkspaceView.list,
    this.isSidebarCollapsed = false,
    required this.currentUser,
    this.availableUsers = const [],
  });

  @override
  List<Object?> get props => [
        uiState,
        failure,
        modulesState,
        versionsState,
        selectedModuleCode,
        selectedVersionCode,
        activeView,
        isSidebarCollapsed,
        currentUser,
        availableUsers,
      ];

  @override
  WorkspaceState copyWith({
    UiState? uiState,
    Failure? Function()? failure,
    SubState<List<OnyxModule>>? modulesState,
    SubState<List<OnyxVersion>>? versionsState,
    String? selectedModuleCode,
    String? selectedVersionCode,
    WorkspaceView? activeView,
    bool? isSidebarCollapsed,
    UserProfile? currentUser,
    List<UserProfile>? availableUsers,
  }) {
    return WorkspaceState(
      uiState: uiState ?? this.uiState,
      failure: failure != null ? failure.copy : this.failure,
      modulesState: modulesState ?? this.modulesState,
      versionsState: versionsState ?? this.versionsState,
      selectedModuleCode: selectedModuleCode ?? this.selectedModuleCode,
      selectedVersionCode: selectedVersionCode ?? this.selectedVersionCode,
      activeView: activeView ?? this.activeView,
      isSidebarCollapsed: isSidebarCollapsed ?? this.isSidebarCollapsed,
      currentUser: currentUser ?? this.currentUser,
      availableUsers: availableUsers ?? this.availableUsers,
    );
  }
}
