import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_priority_flag.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_status_pill.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onTap;
  final ValueChanged<TaskEntity>? onStatusChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
          width: 1,
        ),
      ),
      color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        hoverColor: isDark ? ClickUpColors.darkCardHover : ClickUpColors.lightCardHover,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: ID + Module + Priority + Status
              Row(
                children: [
                  TaskIdBadge(formattedId: task.formattedId),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.screenName,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TaskPriorityFlag(
                    priority: task.priority,
                    onPriorityChanged: (p) => onStatusChanged?.call(task.copyWith(priority: p)),
                  ),
                  const SizedBox(width: 6),
                  TaskStatusPill(
                    status: task.status,
                    onStatusChanged: (s) => onStatusChanged?.call(task.copyWith(status: s)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                task.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),

              // Footer: Type + Assignees + Hours
              Row(
                children: [
                  Icon(task.taskType.icon, size: 14, color: task.taskType.color),
                  const SizedBox(width: 4),
                  Text(
                    task.taskType.label,
                    style: TextStyle(fontSize: 10, color: task.taskType.color),
                  ),
                  const Spacer(),

                  // Assignees avatars / chips
                  if (task.frontendDevName != null) ...[
                    _buildAssigneeAvatar(task.frontendDevName!, Colors.teal, 'FE'),
                    const SizedBox(width: 4),
                  ],
                  if (task.backendDevName != null) ...[
                    _buildAssigneeAvatar(task.backendDevName!, Colors.deepPurple, 'BE'),
                    const SizedBox(width: 4),
                  ],

                  // Hours
                  if (task.estimatedHours > 0 || task.actualHours > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${task.actualHours > 0 ? task.actualHours : task.estimatedHours}h',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssigneeAvatar(String name, Color color, String prefix) {
    final initials = name.length > 2 ? name.substring(0, 2).toUpperCase() : name;
    return Tooltip(
      message: '$prefix: $name',
      child: CircleAvatar(
        radius: 11,
        backgroundColor: color.withValues(alpha: 0.2),
        child: Text(
          initials,
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
