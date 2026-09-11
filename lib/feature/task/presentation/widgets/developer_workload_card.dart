import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';

class DeveloperWorkloadCard extends StatelessWidget {
  final String devName;
  final List<TaskEntity> tasks;
  final bool isDark;

  const DeveloperWorkloadCard({
    super.key,
    required this.devName,
    required this.tasks,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final totalEst = tasks.fold<double>(0.0, (sum, t) => sum + t.estimatedHours);
    final totalAct = tasks.fold<double>(0.0, (sum, t) => sum + t.actualHours);
    final completedCount = tasks.where((t) => t.status.value.contains('solved') || t.status.value == 'closed').length;
    final progress = tasks.isEmpty ? 0.0 : (completedCount / tasks.length);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
        ),
      ),
      color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar + Name + Metrics
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: ClickUpColors.primary.withValues(alpha: 0.2),
                  child: Text(
                    devName.substring(0, devName.length >= 2 ? 2 : 1).toUpperCase(),
                    style: const TextStyle(
                      color: ClickUpColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      devName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      '${tasks.length} ${AppStrings.assignedTasksCount.tr()} ($completedCount ${AppStrings.completedCount.tr()})',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? ClickUpColors.neutral400 : ClickUpColors.neutral500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ClickUpColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${AppStrings.estLabel.tr()}: ${totalEst.toStringAsFixed(1)}h | ${AppStrings.actLabel.tr()}: ${totalAct.toStringAsFixed(1)}h',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: ClickUpColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Linear Progress Indicator
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: isDark ? ClickUpColors.neutral700 : ClickUpColors.neutral200,
                valueColor: const AlwaysStoppedAnimation<Color>(ClickUpColors.primary),
              ),
            ),
            const SizedBox(height: 12),

            // Assigned Tasks Badges
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: tasks.map((t) {
                return TaskIdBadge(formattedId: t.formattedId);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
