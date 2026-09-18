import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/assignee_avatar_badge.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/clickup_status_ring.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_priority_flag.dart';

class TaskMobileCardTile extends HookWidget {
  final TaskEntity task;
  final bool isDark;
  final ValueChanged<TaskEntity> onTaskTap;
  final void Function(TaskEntity task, TaskStatus newStatus) onStatusChanged;
  final void Function(TaskEntity task, TaskPriority newPriority)? onPriorityChanged;

  const TaskMobileCardTile({
    super.key,
    required this.task,
    required this.isDark,
    required this.onTaskTap,
    required this.onStatusChanged,
    this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final devName = task.frontendDevName ?? task.backendDevName ?? task.middleDevName ?? 'Unassigned';
    final hasDueDate = task.dueDate != null;
    final isOverdue = hasDueDate && task.dueDate!.isBefore(DateTime.now());

    return InkWell(
      onTap: () => onTaskTap(task),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? OnyxColors.darkSurface : OnyxColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Status Ring, Task ID, Priority Flag
            Row(
              children: [
                ClickUpStatusRing(
                  status: task.status,
                  size: 18,
                  onTap: () {
                    final nextStatus = switch (task.status) {
                      TaskStatus.open => TaskStatus.inProgress,
                      TaskStatus.inProgress => TaskStatus.backendSolved,
                      TaskStatus.backendSolved => TaskStatus.qaTesting,
                      TaskStatus.qaTesting => TaskStatus.closed,
                      _ => TaskStatus.open,
                    };
                    onStatusChanged(task, nextStatus);
                  },
                ),
                const SizedBox(width: 8),
                TaskIdBadge(
                  formattedId: task.displayId,
                  onTap: () => onTaskTap(task),
                ),
                const Spacer(),
                TaskPriorityFlag(
                  priority: task.priority,
                  onPriorityChanged: onPriorityChanged != null ? (p) => onPriorityChanged!(task, p) : null,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Task Title
            Text(
              task.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                decoration: task.status == TaskStatus.closed ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 10),

            // Bottom Meta Row: Screen tag, Subtasks, Assignee, Due Date
            Row(
              children: [
                if (task.screenName.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? OnyxColors.neutral800 : OnyxColors.neutral100,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isDark ? OnyxColors.neutral700 : OnyxColors.neutral200,
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      task.screenName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                if (task.totalSubtasks > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: task.completedSubtasks == task.totalSubtasks
                          ? OnyxColors.success.withValues(alpha: 0.12)
                          : (isDark ? OnyxColors.neutral800 : OnyxColors.neutral100),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: task.completedSubtasks == task.totalSubtasks
                            ? OnyxColors.success.withValues(alpha: 0.4)
                            : (isDark ? OnyxColors.neutral700 : OnyxColors.neutral200),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.diagramProject,
                          size: 9,
                          color: task.completedSubtasks == task.totalSubtasks
                              ? OnyxColors.success
                              : (isDark ? OnyxColors.neutral400 : OnyxColors.neutral600),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${task.completedSubtasks}/${task.totalSubtasks}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: task.completedSubtasks == task.totalSubtasks
                                ? OnyxColors.success
                                : (isDark ? OnyxColors.neutral300 : OnyxColors.neutral600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                const Spacer(),
                if (hasDueDate) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.calendar,
                        size: 10,
                        color: isOverdue ? OnyxColors.danger : (isDark ? OnyxColors.neutral500 : OnyxColors.neutral400),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('M/d/yy').format(task.dueDate!),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                          color: isOverdue ? OnyxColors.danger : (isDark ? OnyxColors.neutral400 : OnyxColors.neutral600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                ],
                AssigneeAvatarBadge(name: devName, size: 22),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
