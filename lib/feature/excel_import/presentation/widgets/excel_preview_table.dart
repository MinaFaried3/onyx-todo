import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';

class ExcelPreviewTable extends StatelessWidget {
  final List<TaskEntity> tasks;
  final bool isDark;

  const ExcelPreviewTable({
    super.key,
    required this.tasks,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
        ),
      ),
      child: ListView.builder(
        itemCount: tasks.length > 100 ? 100 : tasks.length,
        itemBuilder: (context, index) {
          final t = tasks[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                TaskIdBadge(formattedId: t.formattedId),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? OnyxColors.neutral700 : OnyxColors.neutral200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    t.moduleCode,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: OnyxColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    t.screenName,
                    style: const TextStyle(fontSize: 10, color: OnyxColors.primary),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t.title,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (t.frontendDevName != null) ...[
                  Text(
                    t.frontendDevName!,
                    style: const TextStyle(fontSize: 10, color: OnyxColors.teal),
                  ),
                  const SizedBox(width: 6),
                ],
                if (t.backendDevName != null) ...[
                  Text(
                    t.backendDevName!,
                    style: const TextStyle(fontSize: 10, color: OnyxColors.purple),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  t.status.label,
                  style: TextStyle(
                    fontSize: 10,
                    color: t.status.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
