import 'package:onyx_todo/core/controller/cubit/base_cubit.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/feature/auth/domain/repositories/auth_repository.dart';
import 'package:onyx_todo/feature/workspace/domain/repositories/workspace_repository.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';

class WorkspaceCubit extends BaseCubit<WorkspaceState> {
  final WorkspaceRepository _workspaceRepository;
  final AuthRepository _authRepository;

  WorkspaceCubit({
    required WorkspaceRepository workspaceRepository,
    required AuthRepository authRepository,
  })  : _workspaceRepository = workspaceRepository,
        _authRepository = authRepository,
        super(WorkspaceState(
          currentUser: authRepository.getCurrentUser(),
          availableUsers: authRepository.getAllUsers(),
        ));

  Future<void> init() async {
    emit(state.copyWith(
      modulesState: state.modulesState.copyWith(state: UiState.loading),
      versionsState: state.versionsState.copyWith(state: UiState.loading),
    ));

    final (modulesRes, versionsRes) = await (
      _workspaceRepository.getModules(),
      _workspaceRepository.getVersions(),
    ).wait;

    modulesRes.fold(
      (failure) => emit(state.copyWith(
        modulesState: state.modulesState.copyWith(
          state: UiState.failed,
          failure: () => failure,
        ),
      )),
      (modules) => emit(state.copyWith(
        modulesState: state.modulesState.copyWith(
          state: UiState.succeed,
          data: modules,
        ),
      )),
    );

    versionsRes.fold(
      (failure) => emit(state.copyWith(
        versionsState: state.versionsState.copyWith(
          state: UiState.failed,
          failure: () => failure,
        ),
      )),
      (versions) => emit(state.copyWith(
        versionsState: state.versionsState.copyWith(
          state: UiState.succeed,
          data: versions,
        ),
      )),
    );
  }

  void selectModule(String moduleCode) {
    if (state.selectedModuleCode != moduleCode) {
      emit(state.copyWith(selectedModuleCode: moduleCode));
    }
  }

  void selectVersion(String versionCode) {
    if (state.selectedVersionCode != versionCode) {
      emit(state.copyWith(selectedVersionCode: versionCode));
    }
  }

  void setView(WorkspaceView view) {
    if (state.activeView != view) {
      emit(state.copyWith(activeView: view));
    }
  }

  void toggleSidebar() {
    emit(state.copyWith(isSidebarCollapsed: !state.isSidebarCollapsed));
  }

  Future<void> switchUser(String userId) async {
    final res = await _authRepository.switchUser(userId);
    res.fold(
      (failure) => emit(state.copyWith(failure: () => failure)),
      (user) => emit(state.copyWith(currentUser: user)),
    );
  }
}
