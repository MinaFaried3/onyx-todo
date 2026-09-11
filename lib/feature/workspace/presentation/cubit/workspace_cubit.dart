import 'package:onyx_todo/core/controller/cubit/base_cubit.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/feature/auth/domain/repositories/auth_repository.dart';
import 'package:onyx_todo/feature/notification/domain/entities/system_notification_entity.dart';
import 'package:onyx_todo/feature/notification/domain/repositories/notification_repository.dart';
import 'package:onyx_todo/feature/team/domain/entities/team_entity.dart';
import 'package:onyx_todo/feature/team/domain/repositories/team_repository.dart';
import 'package:onyx_todo/feature/workspace/domain/repositories/workspace_repository.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';

class WorkspaceCubit extends BaseCubit<WorkspaceState> {
  final WorkspaceRepository workspaceRepository;
  final AuthRepository authRepository;
  final TeamRepository teamRepository;
  final NotificationRepository notificationRepository;

  WorkspaceCubit({
    required this.workspaceRepository,
    required this.authRepository,
    required this.teamRepository,
    required this.notificationRepository,
  }) : super(WorkspaceState(
          currentUser: authRepository.getCurrentUser(),
          availableUsers: authRepository.getAllUsers(),
        ));

  Future<void> init() async {
    emit(state.copyWith(
      modulesState: state.modulesState.copyWith(state: UiState.loading),
      versionsState: state.versionsState.copyWith(state: UiState.loading),
      usersState: state.usersState.copyWith(state: UiState.loading),
      teamsState: state.teamsState.copyWith(state: UiState.loading),
      notificationsState: state.notificationsState.copyWith(state: UiState.loading),
    ));

    // Parallel fetch with preserved static types
    final modulesFuture = workspaceRepository.getModules();
    final versionsFuture = workspaceRepository.getVersions();
    final usersFuture = authRepository.fetchUsers();
    final teamsFuture = teamRepository.getTeams();
    final notifsFuture = notificationRepository.getNotifications(state.currentUser.id);

    final modulesRes = await modulesFuture;
    final versionsRes = await versionsFuture;
    final usersRes = await usersFuture;
    final teamsRes = await teamsFuture;
    final notifsRes = await notifsFuture;

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

    usersRes.fold(
      (failure) => emit(state.copyWith(
        usersState: state.usersState.copyWith(
          state: UiState.failed,
          failure: () => failure,
        ),
      )),
      (users) {
        final currentMatch = users.where((u) => u.id == state.currentUser.id).firstOrNull;
        emit(state.copyWith(
          usersState: state.usersState.copyWith(
            state: UiState.succeed,
            data: users,
          ),
          availableUsers: users,
          currentUser: currentMatch ?? state.currentUser,
        ));
      },
    );

    teamsRes.fold(
      (failure) => emit(state.copyWith(
        teamsState: state.teamsState.copyWith(
          state: UiState.failed,
          failure: () => failure,
        ),
      )),
      (teams) => emit(state.copyWith(
        teamsState: state.teamsState.copyWith(
          state: UiState.succeed,
          data: teams,
        ),
      )),
    );

    notifsRes.fold(
      (failure) => emit(state.copyWith(
        notificationsState: state.notificationsState.copyWith(
          state: UiState.failed,
          failure: () => failure,
        ),
      )),
      (notifs) => emit(state.copyWith(
        notificationsState: state.notificationsState.copyWith(
          state: UiState.succeed,
          data: notifs,
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
    final res = await authRepository.switchUser(userId);
    res.fold(
      (failure) => emit(state.copyWith(failure: () => failure)),
      (user) {
        emit(state.copyWith(currentUser: user));
        // Refresh notifications for this newly switched user
        loadNotifications();
      },
    );
  }

  Future<void> refreshUsers() async {
    final res = await authRepository.fetchUsers();
    res.fold(
      (failure) => emit(state.copyWith(failure: () => failure)),
      (users) {
        final currentMatch = users.where((u) => u.id == state.currentUser.id).firstOrNull;
        emit(state.copyWith(
          usersState: state.usersState.copyWith(
            state: UiState.succeed,
            data: users,
          ),
          availableUsers: users,
          currentUser: currentMatch ?? state.currentUser,
        ));
      },
    );
  }

  Future<void> updateUserRole(String userId, UserRole newRole) async {
    final users = state.usersState.data ?? state.availableUsers;
    final target = users.where((u) => u.id == userId).firstOrNull;
    if (target != null) {
      final updated = target.copyWith(role: newRole);
      final res = await authRepository.saveUser(updated);
      res.fold(
        (failure) => emit(state.copyWith(failure: () => failure)),
        (_) => refreshUsers(),
      );
    }
  }

  Future<void> assignUserToTeam(String userId, String teamId) async {
    final users = state.usersState.data ?? state.availableUsers;
    final target = users.where((u) => u.id == userId).firstOrNull;
    if (target != null) {
      final updated = target.copyWith(teamId: teamId);
      await authRepository.saveUser(updated);
      await teamRepository.assignMember(teamId, userId);
      await Future.wait([refreshUsers(), refreshTeams()]);
    }
  }

  Future<void> resetUserPassword(String email) async {
    await authRepository.resetPassword(email);
  }

  Future<void> refreshTeams() async {
    final res = await teamRepository.getTeams();
    res.fold(
      (failure) => emit(state.copyWith(failure: () => failure)),
      (teams) => emit(state.copyWith(
        teamsState: state.teamsState.copyWith(
          state: UiState.succeed,
          data: teams,
        ),
      )),
    );
  }

  Future<void> createTeam(TeamEntity team) async {
    final res = await teamRepository.createTeam(team);
    res.fold(
      (failure) => emit(state.copyWith(failure: () => failure)),
      (_) => refreshTeams(),
    );
  }

  Future<void> updateTeam(TeamEntity team) async {
    final res = await teamRepository.updateTeam(team);
    res.fold(
      (failure) => emit(state.copyWith(failure: () => failure)),
      (_) => refreshTeams(),
    );
  }

  Future<void> deleteTeam(String teamId) async {
    final res = await teamRepository.deleteTeam(teamId);
    res.fold(
      (failure) => emit(state.copyWith(failure: () => failure)),
      (_) => refreshTeams(),
    );
  }

  Future<void> loadNotifications() async {
    final res = await notificationRepository.getNotifications(state.currentUser.id);
    res.fold(
      (failure) => emit(state.copyWith(failure: () => failure)),
      (notifs) => emit(state.copyWith(
        notificationsState: state.notificationsState.copyWith(
          state: UiState.succeed,
          data: notifs,
        ),
      )),
    );
  }

  Future<void> markNotificationAsRead(String id) async {
    await notificationRepository.markAsRead(id);
    loadNotifications();
  }

  Future<void> markAllNotificationsAsRead() async {
    await notificationRepository.markAllAsRead(state.currentUser.id);
    loadNotifications();
  }

  Future<void> sendNotification({
    required String title,
    required String message,
    String recipientUserId = 'ALL',
    String? taskId,
    NotificationType type = NotificationType.systemAnnouncement,
  }) async {
    final notif = SystemNotificationEntity(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      recipientUserId: recipientUserId,
      taskId: taskId,
      title: title,
      message: message,
      type: type,
      isRead: false,
    );
    await notificationRepository.sendNotification(notif);
    loadNotifications();
  }
}
