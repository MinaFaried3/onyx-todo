import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/cubit/tasks_cubit.dart';
import 'package:onyx_todo/feature/task/presentation/cubit/tasks_state.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/status_group_section.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_create_dialog.dart';

enum TaskGroupBy { status, assignee }

class OnyxListView extends HookWidget {
  final List<TaskEntity> tasks;

  const OnyxListView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final tasksCubit = context.tasksCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final groupBy = useState<TaskGroupBy>(TaskGroupBy.status);

    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.inbox,
                  size: 48,
                  color: isDark ? OnyxColors.neutral600 : OnyxColors.neutral400,
                ),
                const SizedBox(height: 12),
                Text(
                  AppStrings.noTasksFound.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        // ─── Grouping Computation ─────────────────────────────────────────────
        List<Widget> groupWidgets = [];

        if (groupBy.value == TaskGroupBy.status) {
          final Map<TaskStatus, List<TaskEntity>> grouped = {};
          for (final status in TaskStatus.values) {
            grouped[status] = [];
          }
          for (final task in tasks) {
            grouped[task.status]?.add(task);
          }

          groupWidgets = TaskStatus.values.map((status) {
            final statusTasks = grouped[status] ?? [];
            return StatusGroupSection(
              title: status.label,
              status: status,
              tasks: statusTasks,
              isDark: isDark,
              onTaskTap: (t) => tasksCubit.selectTask(t),
              onStatusChanged: (task, newStatus) {
                tasksCubit.updateTaskStatus(
                  taskId: task.id,
                  newStatus: newStatus,
                  authorName: 'User',
                );
              },
              onAddTask: () {
                showDialog(
                  context: context,
                  builder: (ctx) => BlocProvider.value(
                    value: tasksCubit,
                    child: TaskCreateDialog(
                      defaultModuleCode: state.activeModuleCode ?? 'GNR',
                      defaultVersion: state.activeVersionCode ?? 'V5.1.8',
                    ),
                  ),
                );
              },
            );
          }).toList();
        } else {
          // Group by Assignee
          final Map<String, List<TaskEntity>> grouped = {};
          for (final task in tasks) {
            final dev = task.frontendDevName ?? task.backendDevName ?? task.middleDevName ?? 'Unassigned';
            grouped.putIfAbsent(dev, () => []).add(task);
          }

          groupWidgets = grouped.entries.map((entry) {
            return StatusGroupSection(
              title: entry.key,
              assigneeName: entry.key,
              tasks: entry.value,
              isDark: isDark,
              onTaskTap: (t) => tasksCubit.selectTask(t),
              onStatusChanged: (task, newStatus) {
                tasksCubit.updateTaskStatus(
                  taskId: task.id,
                  newStatus: newStatus,
                  authorName: 'User',
                );
              },
              onAddTask: () {
                showDialog(
                  context: context,
                  builder: (ctx) => BlocProvider.value(
                    value: tasksCubit,
                    child: TaskCreateDialog(
                      defaultModuleCode: state.activeModuleCode ?? 'GNR',
                      defaultVersion: state.activeVersionCode ?? 'V5.1.8',
                    ),
                  ),
                );
              },
            );
          }).toList();
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: [
            // ─── ClickUp Sub-Toolbar (Group by, Filter Pill) ─────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  // Group By Selector Pill
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? OnyxColors.darkCard : OnyxColors.neutral100,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDark ? OnyxColors.darkBorder : OnyxColors.neutral300,
                        width: 0.8,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(FontAwesomeIcons.layerGroup, size: 11, color: OnyxColors.primary),
                        const SizedBox(width: 6),
                        DropdownButton<TaskGroupBy>(
                          value: groupBy.value,
                          underline: const SizedBox(),
                          isDense: true,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: TaskGroupBy.status,
                              child: Text('Group: Status'),
                            ),
                            DropdownMenuItem(
                              value: TaskGroupBy.assignee,
                              child: Text('Group: Assignee'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) groupBy.value = val;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Active Filter Count Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: OnyxColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: OnyxColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(FontAwesomeIcons.filter, size: 10, color: OnyxColors.primary),
                        const SizedBox(width: 5),
                        Text(
                          '${tasks.length} ${AppStrings.tasks.tr()}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: OnyxColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Fast Search Box
                  SizedBox(
                    width: 200,
                    height: 32,
                    child: TextField(
                      onChanged: (q) => tasksCubit.setSearchQuery(q),
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: '${AppStrings.search.tr()}...',
                        prefixIcon: const Center(
                          widthFactor: 1.0,
                          child: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 11, color: OnyxColors.neutral400),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 6),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Group Sections ──────────────────────────────────────────────────
            ...groupWidgets,

            if (state.hasMore)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: state.isLoadingMore
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: OnyxColors.primary,
                            side: const BorderSide(color: OnyxColors.primary, width: 1.5),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          icon: const FaIcon(FontAwesomeIcons.anglesDown, size: 13),
                          label: Text(
                            AppStrings.loadMoreTasks.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          onPressed: () => tasksCubit.loadMoreTasks(),
                        ),
                ),
              ),
          ],
        );
      },
    );
  }
}
