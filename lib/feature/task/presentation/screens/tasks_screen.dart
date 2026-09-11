import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/task/presentation/cubit/tasks_cubit.dart';
import 'package:onyx_todo/feature/task/presentation/cubit/tasks_state.dart';
import 'package:onyx_todo/feature/task/presentation/views/clickup_analytics_view.dart';
import 'package:onyx_todo/feature/task/presentation/views/clickup_board_view.dart';
import 'package:onyx_todo/feature/task/presentation/views/clickup_list_view.dart';
import 'package:onyx_todo/feature/task/presentation/views/clickup_workload_view.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_create_dialog.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_drawer_detail.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';

class TasksScreen extends HookWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksCubit = context.tasksCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final searchController = useTextEditingController();

    // Re-fetch tasks whenever active module or version changes in workspace
    final activeModule = context.select<WorkspaceCubit, String>(
      (c) => c.state.selectedModuleCode,
    );
    final activeVersion = context.select<WorkspaceCubit, String>(
      (c) => c.state.selectedVersionCode,
    );

    useEffect(() {
      tasksCubit.fetchTasks(
        moduleCode: activeModule == 'ALL' ? null : activeModule,
        version: activeVersion == 'ALL' ? null : activeVersion,
      );
      return null;
    }, [activeModule, activeVersion]);

    final activeView = context.select<WorkspaceCubit, WorkspaceView>(
      (c) => c.state.activeView,
    );

    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        final filteredTasks = state.filteredTasks;
        final selectedTask = state.selectedTask;

        return Row(
          children: [
            // Main Tasks Canvas
            Expanded(
              child: Column(
                children: [
                  // Filter and Actions Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Search Box
                        SizedBox(
                          width: 240,
                          height: 36,
                          child: TextField(
                            controller: searchController,
                            onChanged: (v) => tasksCubit.setSearchQuery(v),
                            style: const TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              hintText: AppStrings.search.tr(),
                              prefixIcon: const Center(
                                widthFactor: 1.0,
                                child: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 13, color: ClickUpColors.neutral400),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 6),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Priority Filter Dropdown
                        DropdownButton<TaskPriority?>(
                          value: state.priorityFilter,
                          hint: Text(
                            AppStrings.priority.tr(),
                            style: const TextStyle(fontSize: 12),
                          ),
                          underline: const SizedBox(),
                          items: [
                            DropdownMenuItem(
                              value: null,
                              child: Text(AppStrings.all.tr(), style: const TextStyle(fontSize: 12)),
                            ),
                            ...TaskPriority.values.map((p) {
                              return DropdownMenuItem(
                                value: p,
                                child: Text(p.label, style: const TextStyle(fontSize: 12)),
                              );
                            }),
                          ],
                          onChanged: (p) => tasksCubit.setPriorityFilter(p),
                        ),
                        const SizedBox(width: 12),

                        // Status Filter Dropdown
                        DropdownButton<TaskStatus?>(
                          value: state.statusFilter,
                          hint: Text(
                            AppStrings.status.tr(),
                            style: const TextStyle(fontSize: 12),
                          ),
                          underline: const SizedBox(),
                          items: [
                            DropdownMenuItem(
                              value: null,
                              child: Text(AppStrings.all.tr(), style: const TextStyle(fontSize: 12)),
                            ),
                            ...TaskStatus.values.map((s) {
                              return DropdownMenuItem(
                                value: s,
                                child: Text(s.label, style: const TextStyle(fontSize: 12)),
                              );
                            }),
                          ],
                          onChanged: (s) => tasksCubit.setStatusFilter(s),
                        ),
                        const Spacer(),

                        // Create Task Button
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ClickUpColors.primary,
                            foregroundColor: ClickUpColors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          icon: const FaIcon(FontAwesomeIcons.plus, size: 12),
                          label: Text(
                            AppStrings.createTask.tr(),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => TaskCreateDialog(
                                defaultVersion: activeVersion == 'ALL' ? 'V5.1.8' : activeVersion,
                                defaultModuleCode: activeModule == 'ALL' ? 'GNR' : activeModule,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // View Content
                  Expanded(
                    child: state.tasksState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : switch (activeView) {
                            WorkspaceView.board => ClickUpBoardView(tasks: filteredTasks),
                            WorkspaceView.workload => ClickUpWorkloadView(tasks: filteredTasks),
                            WorkspaceView.analytics => ClickUpAnalyticsView(tasks: filteredTasks),
                            _ => ClickUpListView(tasks: filteredTasks),
                          },
                  ),
                ],
              ),
            ),

            // Side Detail Drawer
            if (selectedTask != null)
              TaskDrawerDetail(
                task: selectedTask,
                onClose: () => tasksCubit.selectTask(null),
              ),
          ],
        );
      },
    );
  }
}
