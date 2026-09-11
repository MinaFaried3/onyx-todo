import 'package:flutter/material.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';

class TaskPriorityFlag extends StatelessWidget {
  final TaskPriority priority;
  final ValueChanged<TaskPriority>? onPriorityChanged;

  const TaskPriorityFlag({
    super.key,
    required this.priority,
    this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final flagColor = priority.color;

    if (onPriorityChanged == null) {
      return _buildIcon(flagColor);
    }

    return PopupMenuButton<TaskPriority>(
      tooltip: '',
      onSelected: onPriorityChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: (context) => TaskPriority.values.map((p) {
        return PopupMenuItem<TaskPriority>(
          value: p,
          child: Row(
            children: [
              Icon(Icons.flag_rounded, size: 16, color: p.color),
              const SizedBox(width: 8),
              Text(
                p.label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      }).toList(),
      child: _buildIcon(flagColor),
    );
  }

  Widget _buildIcon(Color flagColor) {
    return Tooltip(
      message: priority.label,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: flagColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          Icons.flag_rounded,
          size: 14,
          color: flagColor,
        ),
      ),
    );
  }
}
