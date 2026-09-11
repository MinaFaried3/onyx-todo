import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_priority_flag.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_status_pill.dart';

class StatusGroupSection extends HookWidget {
  final TaskStatus status;
  final List<TaskEntity> tasks;
  final bool isDark;
  final ValueChanged<TaskEntity> onTaskTap;
  final void Function(TaskEntity task, TaskStatus newStatus) onStatusChanged;

  const StatusGroupSection({
    super.key,
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
        color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
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
                  FaIcon(
                    isExpanded.value ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronRight,
                    size: 11,
                    color: status.color,
                  ),
                  const SizedBox(width: 8),
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
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
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
                        color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      TaskIdBadge(
                        formattedId: task.formattedId,
                        onTap: () => onTaskTap(task),
                      ),
                      const SizedBox(width: 12),
                      if (task.screenName.isNotEmpty) ...[
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 130),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? OnyxColors.neutral700 : OnyxColors.neutral200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              task.screenName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
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
                        _buildDevChip(task.frontendDevName!, OnyxColors.info),
                        const SizedBox(width: 6),
                      ],
                      if (task.backendDevName != null) ...[
                        _buildDevChip(task.backendDevName!, OnyxColors.accentPurple),
                        const SizedBox(width: 6),
                      ],
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
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: OnyxColors.primary),
                              ),
                            ],
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
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 85),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
