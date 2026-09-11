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

class OnyxListView extends HookWidget {
  final List<TaskEntity> tasks;

  const OnyxListView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final tasksCubit = context.tasksCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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

        // Group tasks by status
        final Map<TaskStatus, List<TaskEntity>> grouped = {};
        for (final status in TaskStatus.values) {
          grouped[status] = [];
        }
        for (final task in tasks) {
          grouped[task.status]?.add(task);
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            ...TaskStatus.values.map((status) {
              final statusTasks = grouped[status] ?? [];
              return StatusGroupSection(
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
              );
            }),
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
