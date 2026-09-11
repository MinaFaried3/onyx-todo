import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/status_group_section.dart';

class ClickUpListView extends HookWidget {
  final List<TaskEntity> tasks;

  const ClickUpListView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final tasksCubit = context.tasksCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.inbox,
              size: 48,
              color: isDark ? ClickUpColors.neutral600 : ClickUpColors.neutral400,
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.noTasksFound.tr(),
              style: TextStyle(
                fontSize: 14,
                color: isDark ? ClickUpColors.neutral400 : ClickUpColors.neutral500,
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
      children: TaskStatus.values.map((status) {
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
      }).toList(),
    );
  }
}
