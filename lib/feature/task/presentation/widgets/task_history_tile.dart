import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_history_item.dart';

class TaskHistoryTile extends StatelessWidget {
  final TaskHistoryItem item;

  const TaskHistoryTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeStr = DateFormat('yyyy/MM/dd HH:mm').format(item.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: ClickUpColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.authorName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      timeStr,
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? ClickUpColors.neutral400 : ClickUpColors.neutral500,
                      ),
                    ),
                  ],
                ),
                Text(
                  item.details,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? ClickUpColors.neutral300 : ClickUpColors.neutral700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
