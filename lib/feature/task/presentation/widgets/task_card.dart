import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
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
          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
          width: 1,
        ),
      ),
      color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        hoverColor: isDark ? OnyxColors.darkCardHover : OnyxColors.lightCardHover,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: ID + Module + Priority + Status
              Row(
                children: [
                  TaskIdBadge(
                    formattedId: task.formattedId,
                    onTap: onTap,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? OnyxColors.neutral700 : OnyxColors.neutral200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.screenName,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
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
                  color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),

              // Footer: Type + Assignees + Hours
              Row(
                children: [
                  FaIcon(task.taskType.icon, size: 12, color: task.taskType.color),
                  const SizedBox(width: 5),
                  Text(
                    task.taskType.label,
                    style: TextStyle(fontSize: 10, color: task.taskType.color, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),

                  // Assignees avatars / chips
                  if (task.frontendDevName != null) ...[
                    _buildAssigneeAvatar(task.frontendDevName!, OnyxColors.info, 'FE'),
                    const SizedBox(width: 4),
                  ],
                  if (task.backendDevName != null) ...[
                    _buildAssigneeAvatar(task.backendDevName!, OnyxColors.accentPurple, 'BE'),
                    const SizedBox(width: 4),
                  ],

                  // Hours
                  if (task.estimatedHours > 0 || task.actualHours > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: OnyxColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(FontAwesomeIcons.clock, size: 9, color: OnyxColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            '${task.actualHours > 0 ? task.actualHours : task.estimatedHours}h',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: OnyxColors.primary),
                          ),
                        ],
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
