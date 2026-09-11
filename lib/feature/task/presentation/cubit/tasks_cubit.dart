import 'package:onyx_todo/core/controller/cubit/base_cubit.dart';
import 'package:onyx_todo/core/controller/cubit/sub_state.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/domain/repositories/task_repository.dart';
import 'package:onyx_todo/feature/task/presentation/cubit/tasks_state.dart';

class TasksCubit extends BaseCubit<TasksState> {
  final TaskRepository _taskRepository;

  TasksCubit({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(const TasksState());

  Future<void> fetchTasks({
    String? moduleCode,
    String? version,
    String? status,
  }) async {
    emit(state.copyWith(
      tasksState: state.tasksState.copyWith(state: UiState.loading),
    ));

    final res = await _taskRepository.getTasks(
      moduleCode: moduleCode,
      version: version,
      status: status,
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
      )),
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
    double estimatedHours = 0.0,
    String? devNotes,
  }) async {
    emit(state.copyWith(
      createTaskState: state.createTaskState.copyWith(state: UiState.loading),
    ));

    final res = await _taskRepository.createTask(
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
      (createdTask) {
        final currentList = List<TaskEntity>.from(state.tasksState.data ?? []);
        currentList.insert(0, createdTask);
        emit(state.copyWith(
          createTaskState: state.createTaskState.copyWith(
            state: UiState.succeed,
            data: createdTask,
          ),
          tasksState: state.tasksState.copyWith(data: currentList),
        ));
        return true;
      },
    );
  }

  Future<void> updateTaskStatus({
    required String taskId,
    required TaskStatus newStatus,
    required String authorName,
    String? note,
  }) async {
    // Optimistic UI update
    final currentList = List<TaskEntity>.from(state.tasksState.data ?? []);
    final index = currentList.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final current = currentList[index];
      currentList[index] = current.copyWith(status: newStatus);
      emit(state.copyWith(
        tasksState: state.tasksState.copyWith(data: currentList),
        selectedTask: state.selectedTask?.id == taskId
            ? () => currentList[index]
            : null,
      ));
    }

    final res = await _taskRepository.updateTaskStatus(
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

    final res = await _taskRepository.updateTask(task);
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
