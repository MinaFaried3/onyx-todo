import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';

class TaskStatusPill extends StatelessWidget {
  final TaskStatus status;
  final ValueChanged<TaskStatus>? onStatusChanged;

  const TaskStatusPill({
    super.key,
    required this.status,
    this.onStatusChanged,
  });

  IconData _getStatusIcon(TaskStatus s) {
    return switch (s) {
      TaskStatus.open => FontAwesomeIcons.circleDot,
      TaskStatus.inProgress => FontAwesomeIcons.arrowsRotate,
      TaskStatus.backendSolved => FontAwesomeIcons.server,
      TaskStatus.frontendSolved => FontAwesomeIcons.code,
      TaskStatus.qaTesting => FontAwesomeIcons.flask,
      TaskStatus.closed => FontAwesomeIcons.circleCheck,
    };
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = status.color;

    if (onStatusChanged == null) {
      return _buildBadge(statusColor);
    }

    return PopupMenuButton<TaskStatus>(
      tooltip: '',
      onSelected: onStatusChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: (context) => TaskStatus.values.map((s) {
        return PopupMenuItem<TaskStatus>(
          value: s,
          child: Row(
            children: [
              FaIcon(
                _getStatusIcon(s),
                size: 13,
                color: s.color,
              ),
              const SizedBox(width: 8),
              Text(
                s.label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      }).toList(),
      child: _buildBadge(statusColor, showArrow: true),
    );
  }

  Widget _buildBadge(Color statusColor, {bool showArrow = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: statusColor.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            _getStatusIcon(status),
            size: 11,
            color: statusColor,
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (showArrow) ...[
            const SizedBox(width: 5),
            FaIcon(FontAwesomeIcons.caretDown, size: 10, color: statusColor),
          ],
        ],
      ),
    );
  }
}
