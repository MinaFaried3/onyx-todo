import 'package:onyx_todo/core/controller/cubit/base_cubit.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_history_item.dart';
import 'package:onyx_todo/feature/task/domain/repositories/task_repository.dart';
import 'package:onyx_todo/feature/task/presentation/cubit/tasks_state.dart';

class TasksCubit extends BaseCubit<TasksState> {
  final TaskRepository taskRepository;

  TasksCubit({required this.taskRepository})
      : super(const TasksState());

  Future<void> fetchTasks({
    String? moduleCode,
    String? version,
    String? status,
    bool refresh = true,
  }) async {
    emit(state.copyWith(
      tasksState: state.tasksState.copyWith(state: UiState.loading),
      currentPage: 1,
      hasMore: true,
      activeModuleCode: () => moduleCode,
      activeVersionCode: () => version,
    ));

    final res = await taskRepository.getTasks(
      moduleCode: moduleCode,
      version: version,
      status: status,
      page: 1,
      limit: 25,
    );

    res.fold(
      (failure) => emit(state.copyWith(
        tasksState: state.tasksState.copyWith(
          state: UiState.failed,
          failure: () => failure,
        ),
      )),
      (tasks) => emit(state.copyWith(
        tasksState: state.tasksState.copyWith(
          state: UiState.succeed,
          data: tasks,
        ),
        hasMore: tasks.length >= 25,
        currentPage: 1,
      )),
    );
  }

  Future<void> loadMoreTasks() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    final nextPage = state.currentPage + 1;

    final res = await taskRepository.getTasks(
      moduleCode: state.activeModuleCode,
      version: state.activeVersionCode,
      status: state.statusFilter?.value,
      page: nextPage,
      limit: 25,
    );

    res.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false)),
      (tasks) {
        final currentCount = state.tasksState.data?.length ?? 0;
        final hasMore = tasks.length > currentCount && (tasks.length % 25 == 0);
        emit(state.copyWith(
          tasksState: state.tasksState.copyWith(
            state: UiState.succeed,
            data: tasks,
          ),
          currentPage: nextPage,
          hasMore: hasMore,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<bool> createTask({
    required String version,
    required String moduleCode,
    required String screenName,
    required String title,
    String description = '',
    String taskType = 'task',
    String priority = 'medium',
    String? backendDevName,
    String? frontendDevName,
    String? middleDevName,
    String? qaTesterName,
    List<String>? roleFlow,
    double estimatedHours = 0.0,
    String? devNotes,
  }) async {
    emit(state.copyWith(
      createTaskState: state.createTaskState.copyWith(state: UiState.loading),
    ));

    final res = await taskRepository.createTask(
      version: version,
      moduleCode: moduleCode,
      screenName: screenName,
      title: title,
      description: description,
      taskType: taskType,
      priority: priority,
      backendDevName: backendDevName,
      frontendDevName: frontendDevName,
      middleDevName: middleDevName,
      qaTesterName: qaTesterName,
      roleFlow: roleFlow,
      estimatedHours: estimatedHours,
      devNotes: devNotes,
    );

    return res.fold(
      (failure) {
        emit(state.copyWith(
          createTaskState: state.createTaskState.copyWith(
            state: UiState.failed,
            failure: () => failure,
          ),
        ));
        return false;
      },
      (newTask) {
        final currentList = List<TaskEntity>.from(state.tasksState.data ?? []);
        currentList.insert(0, newTask);
        emit(state.copyWith(
          createTaskState: state.createTaskState.copyWith(
            state: UiState.succeed,
            data: newTask,
          ),
          tasksState: state.tasksState.copyWith(data: currentList),
        ));
        return true;
      },
    );
  }

  /// Sequential role flow transition with sub-statuses: todo -> in_progress -> under_review -> completed
  Future<void> updateRoleSubStatus({
    required String taskId,
    required String subStatus, // 'todo', 'in_progress', 'under_review', 'completed'
    required String authorName,
    String? note,
  }) async {
    final currentList = List<TaskEntity>.from(state.tasksState.data ?? []);
    final index = currentList.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final oldTask = currentList[index];
    TaskEntity updatedTask;
    final updatedHistory = List<TaskHistoryItem>.from(oldTask.history);

    if (subStatus == 'completed') {
      final nextStage = oldTask.nextRoleStage;
      if (nextStage != null) {
        updatedHistory.add(TaskHistoryItem(
          id: 'hist_${DateTime.now().millisecondsSinceEpoch}',
          action: 'role_handoff',
          authorName: authorName,
          timestamp: DateTime.now(),
          details: 'اكتملت مرحلة (${oldTask.currentRoleStage}) ➔ ترحيل تلقائي إلى مرحلة ($nextStage)${note != null ? ' ($note)' : ''}',
          roleStage: nextStage,
          fromStatus: oldTask.currentRoleStage,
          toStatus: nextStage,
        ));
        updatedTask = oldTask.copyWith(
          currentRoleStage: nextStage,
          roleSubStatus: 'todo',
          history: updatedHistory,
        );
      } else {
        updatedHistory.add(TaskHistoryItem(
          id: 'hist_${DateTime.now().millisecondsSinceEpoch}',
          action: 'status_change',
          authorName: authorName,
          timestamp: DateTime.now(),
          details: 'اكتملت كافة مراحل العمل ➔ إغلاق المهمة${note != null ? ' ($note)' : ''}',
          roleStage: oldTask.currentRoleStage,
          toStatus: 'closed',
        ));
        updatedTask = oldTask.copyWith(
          status: TaskStatus.closed,
          roleSubStatus: 'completed',
          resolvedDate: DateTime.now(),
          history: updatedHistory,
        );
      }
    } else {
      final taskStatus = subStatus == 'in_progress' ? TaskStatus.inProgress : oldTask.status;
      updatedHistory.add(TaskHistoryItem(
        id: 'hist_${DateTime.now().millisecondsSinceEpoch}',
        action: 'status_change',
        authorName: authorName,
        timestamp: DateTime.now(),
        details: 'تغيير حالة مرحلة (${oldTask.currentRoleStage}) إلى $subStatus${note != null ? ' ($note)' : ''}',
        roleStage: oldTask.currentRoleStage,
        fromStatus: oldTask.roleSubStatus,
        toStatus: subStatus,
      ));
      updatedTask = oldTask.copyWith(
        status: taskStatus,
        roleSubStatus: subStatus,
        history: updatedHistory,
      );
    }

    currentList[index] = updatedTask;
    emit(state.copyWith(
      tasksState: state.tasksState.copyWith(data: currentList),
      selectedTask: state.selectedTask?.id == taskId ? () => updatedTask : null,
    ));

    await taskRepository.updateTask(updatedTask);
  }

  Future<void> updateTaskStatus({
    required String taskId,
    required TaskStatus newStatus,
    required String authorName,
    String? note,
  }) async {
    // Optimistic UI update with role flow progression and history audit
    final currentList = List<TaskEntity>.from(state.tasksState.data ?? []);
    final index = currentList.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final oldTask = currentList[index];
      String nextRoleStage = oldTask.currentRoleStage;

      // Sequential role flow transitions
      if (newStatus == TaskStatus.backendSolved) {
        if (oldTask.roleFlow.contains('middle')) {
          nextRoleStage = 'middle';
        } else if (oldTask.roleFlow.contains('frontend')) {
          nextRoleStage = 'frontend';
        }
      } else if (newStatus == TaskStatus.frontendSolved) {
        if (oldTask.roleFlow.contains('qa')) {
          nextRoleStage = 'qa';
        }
      }

      final updatedHistory = List<TaskHistoryItem>.from(oldTask.history);
      updatedHistory.add(TaskHistoryItem(
        id: 'hist_${DateTime.now().millisecondsSinceEpoch}',
        action: 'status_change',
        authorName: authorName,
        timestamp: DateTime.now(),
        details: '${oldTask.status.label} ➔ ${newStatus.label}${note != null ? ' ($note)' : ''}',
        roleStage: nextRoleStage,
        fromStatus: oldTask.status.value,
        toStatus: newStatus.value,
      ));

      final updatedTask = oldTask.copyWith(
        status: newStatus,
        currentRoleStage: nextRoleStage,
        history: updatedHistory,
      );

      currentList[index] = updatedTask;
      emit(state.copyWith(
        tasksState: state.tasksState.copyWith(data: currentList),
        selectedTask: state.selectedTask?.id == taskId
            ? () => updatedTask
            : null,
      ));
    }

    final res = await taskRepository.updateTaskStatus(
      taskId: taskId,
      newStatus: newStatus.value,
      authorName: authorName,
      note: note,
    );

    res.fold(
      (failure) => emit(state.copyWith(failure: () => failure)),
      (_) {},
    );
  }

  Future<void> updateTask(TaskEntity task) async {
    final currentList = List<TaskEntity>.from(state.tasksState.data ?? []);
    final index = currentList.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      currentList[index] = task;
      emit(state.copyWith(
        tasksState: state.tasksState.copyWith(data: currentList),
        selectedTask: () => task,
      ));
    }

    final res = await taskRepository.updateTask(task);
    res.fold(
      (failure) => emit(state.copyWith(failure: () => failure)),
      (_) {},
    );
  }

  void selectTask(TaskEntity? task) {
    emit(state.copyWith(selectedTask: () => task));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setPriorityFilter(TaskPriority? priority) {
    emit(state.copyWith(priorityFilter: () => priority));
  }

  void setStatusFilter(TaskStatus? status) {
    emit(state.copyWith(statusFilter: () => status));
  }

  void setAssigneeFilter(String? assignee) {
    emit(state.copyWith(assigneeFilter: () => assignee));
  }

  void clearFilters() {
    emit(state.copyWith(
      searchQuery: '',
      priorityFilter: () => null,
      statusFilter: () => null,
      assigneeFilter: () => null,
    ));
  }
}
