import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_task_item.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/edit_plan_task_dialog.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';

class MyPlanTaskMobileCard extends StatelessWidget {
  final MonthlyPlanTaskItem task;
  final bool isDark;
  final bool canEdit;
  final VoidCallback? onDelete;

  const MyPlanTaskMobileCard({
    super.key,
    required this.task,
    required this.isDark,
    required this.canEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Top Row: Task ID, Module Badge, and Actions
          Row(
            children: [
              TaskIdBadge(formattedId: task.formattedId),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: OnyxColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  task.moduleCode,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: OnyxColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              if (canEdit) ...[
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 12, color: OnyxColors.primary),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => EditPlanTaskDialog(item: task),
                    );
                  },
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.trashCan, size: 12, color: OnyxColors.danger),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  onPressed: onDelete,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            task.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
            ),
          ),
          if (task.screenName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              task.screenName,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
              ),
            ),
          ],
          const SizedBox(height: 10),

          // Metrics Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? OnyxColors.neutral800.withValues(alpha: 0.5) : OnyxColors.neutral100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric(
                  label: AppStrings.estDaysCol.tr(),
                  value: '${task.estimatedDays}d',
                  color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                ),
                _buildMetric(
                  label: AppStrings.estHoursCol.tr(),
                  value: '${task.estimatedHours}h',
                  color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                ),
                _buildMetric(
                  label: AppStrings.actHoursCol.tr(),
                  value: '${task.actualHours}h',
                  color: task.actualHours > 0
                      ? OnyxColors.success
                      : (isDark ? OnyxColors.neutral400 : OnyxColors.neutral500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: OnyxColors.neutral500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
