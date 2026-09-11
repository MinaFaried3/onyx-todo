import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';

class ClickUpWorkloadView extends StatelessWidget {
  final List<TaskEntity> tasks;

  const ClickUpWorkloadView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Aggregate workload per developer
    final Map<String, List<TaskEntity>> devTasks = {};

    for (final task in tasks) {
      if (task.frontendDevName != null && task.frontendDevName!.isNotEmpty) {
        devTasks.putIfAbsent(task.frontendDevName!, () => []).add(task);
      }
      if (task.backendDevName != null && task.backendDevName!.isNotEmpty) {
        devTasks.putIfAbsent(task.backendDevName!, () => []).add(task);
      }
      if (task.middleDevName != null && task.middleDevName!.isNotEmpty) {
        devTasks.putIfAbsent(task.middleDevName!, () => []).add(task);
      }
    }

    if (devTasks.isEmpty) {
      return const Center(
        child: Text(
          'لا يوجد مطورون معينون لمهام حالية',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: devTasks.entries.map((entry) {
        final devName = entry.key;
        final devTaskList = entry.value;

        final totalEst = devTaskList.fold<double>(0.0, (sum, t) => sum + t.estimatedHours);
        final totalAct = devTaskList.fold<double>(0.0, (sum, t) => sum + t.actualHours);
        final completedCount = devTaskList.where((t) => t.status.value.contains('solved') || t.status.value == 'closed').length;
        final progress = devTaskList.isEmpty ? 0.0 : (completedCount / devTaskList.length);

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
                          '${devTaskList.length} مهام مسندة ($completedCount مكتملة)',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'مقدر: ${totalEst.toStringAsFixed(1)}h | فعلي: ${totalAct.toStringAsFixed(1)}h',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
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
                    backgroundColor: isDark ? Colors.white10 : Colors.black12,
                    valueColor: const AlwaysStoppedAnimation<Color>(ClickUpColors.primary),
                  ),
                ),
                const SizedBox(height: 12),

                // Assigned Tasks Badges
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: devTaskList.map((t) {
                    return TaskIdBadge(formattedId: t.formattedId);
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
