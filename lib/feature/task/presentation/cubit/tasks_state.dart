import 'package:onyx_todo/core/controller/cubit/base_state.dart';
import 'package:onyx_todo/core/controller/cubit/sub_state.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/enum/ui_state.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';

final class TasksState extends BaseState {
  final SubState<List<TaskEntity>> tasksState;
  final SubState<TaskEntity> createTaskState;
  final String searchQuery;
  final TaskPriority? priorityFilter;
  final TaskStatus? statusFilter;
  final String? assigneeFilter;
  final TaskEntity? selectedTask;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final String? activeModuleCode;
  final String? activeVersionCode;

  const TasksState({
    super.uiState,
    super.failure,
    this.tasksState = const SubState(),
    this.createTaskState = const SubState(),
    this.searchQuery = '',
    this.priorityFilter,
    this.statusFilter,
    this.assigneeFilter,
    this.selectedTask,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.activeModuleCode,
    this.activeVersionCode,
  });

  List<TaskEntity> get filteredTasks {
    final tasks = tasksState.data ?? [];
    return tasks.where((t) {
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final matchId = t.formattedId.toLowerCase().contains(query);
        final matchTitle = t.title.toLowerCase().contains(query);
        final matchScreen = t.screenName.toLowerCase().contains(query);
        final matchDesc = t.description.toLowerCase().contains(query);
        if (!matchId && !matchTitle && !matchScreen && !matchDesc) return false;
      }
      if (priorityFilter != null && t.priority != priorityFilter) {
        return false;
      }
      if (statusFilter != null && t.status != statusFilter) {
        return false;
      }
      if (assigneeFilter != null && assigneeFilter!.isNotEmpty && assigneeFilter != 'ALL') {
        final matchDev = t.backendDevName == assigneeFilter ||
            t.frontendDevName == assigneeFilter ||
            t.middleDevName == assigneeFilter;
        if (!matchDev) return false;
      }
      return true;
    }).toList();
  }

  @override
  List<Object?> get props => [
        uiState,
        failure,
        tasksState,
        createTaskState,
        searchQuery,
        priorityFilter,
        statusFilter,
        assigneeFilter,
        selectedTask,
        currentPage,
        hasMore,
        isLoadingMore,
        activeModuleCode,
        activeVersionCode,
      ];

  @override
  TasksState copyWith({
    UiState? uiState,
    Failure? Function()? failure,
    SubState<List<TaskEntity>>? tasksState,
    SubState<TaskEntity>? createTaskState,
    String? searchQuery,
    TaskPriority? Function()? priorityFilter,
    TaskStatus? Function()? statusFilter,
    String? Function()? assigneeFilter,
    TaskEntity? Function()? selectedTask,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    String? Function()? activeModuleCode,
    String? Function()? activeVersionCode,
  }) {
    return TasksState(
      uiState: uiState ?? this.uiState,
      failure: failure != null ? failure.copy : this.failure,
      tasksState: tasksState ?? this.tasksState,
      createTaskState: createTaskState ?? this.createTaskState,
      searchQuery: searchQuery ?? this.searchQuery,
      priorityFilter: priorityFilter != null ? priorityFilter() : this.priorityFilter,
      statusFilter: statusFilter != null ? statusFilter() : this.statusFilter,
      assigneeFilter: assigneeFilter != null ? assigneeFilter() : this.assigneeFilter,
      selectedTask: selectedTask != null ? selectedTask() : this.selectedTask,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      activeModuleCode: activeModuleCode != null ? activeModuleCode() : this.activeModuleCode,
      activeVersionCode: activeVersionCode != null ? activeVersionCode() : this.activeVersionCode,
    );
  }
}
