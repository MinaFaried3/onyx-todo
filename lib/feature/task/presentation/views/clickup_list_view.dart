import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_priority_flag.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_status_pill.dart';

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
            Icon(Icons.inbox_rounded, size: 54, color: Colors.grey.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text(
              AppStrings.noTasksFound.tr(),
              style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
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
        return _StatusGroupSection(
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

class _StatusGroupSection extends HookWidget {
  final TaskStatus status;
  final List<TaskEntity> tasks;
  final bool isDark;
  final ValueChanged<TaskEntity> onTaskTap;
  final void Function(TaskEntity task, TaskStatus newStatus) onStatusChanged;

  const _StatusGroupSection({
    required this.status,
    required this.tasks,
    required this.isDark,
    required this.onTaskTap,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(true);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          // Section Header
          InkWell(
            onTap: () => isExpanded.value = !isExpanded.value,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: status.color.withValues(alpha: isDark ? 0.12 : 0.07),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(8),
                  bottom: Radius.circular(isExpanded.value ? 0 : 8),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isExpanded.value ? Icons.arrow_drop_down_rounded : Icons.arrow_right_rounded,
                    color: status.color,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: status.color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status.label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: status.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: status.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${tasks.length}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: status.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Items Table Rows
          if (isExpanded.value)
            ...tasks.map((task) {
              return InkWell(
                onTap: () => onTaskTap(task),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      TaskIdBadge(formattedId: task.formattedId),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          task.screenName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      TaskPriorityFlag(
                        priority: task.priority,
                        onPriorityChanged: (p) => onStatusChanged(task, task.status),
                      ),
                      const SizedBox(width: 12),
                      TaskStatusPill(
                        status: task.status,
                        onStatusChanged: (s) => onStatusChanged(task, s),
                      ),
                      const SizedBox(width: 12),
                      if (task.frontendDevName != null) ...[
                        _buildDevChip(task.frontendDevName!, Colors.teal),
                        const SizedBox(width: 6),
                      ],
                      if (task.backendDevName != null) ...[
                        _buildDevChip(task.backendDevName!, Colors.deepPurple),
                        const SizedBox(width: 6),
                      ],
                      if (task.estimatedHours > 0 || task.actualHours > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${task.actualHours > 0 ? task.actualHours : task.estimatedHours}h',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildDevChip(String name, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        name,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
