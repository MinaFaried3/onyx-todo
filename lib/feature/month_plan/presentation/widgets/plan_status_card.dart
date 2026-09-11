import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';

class PlanStatusCard extends StatelessWidget {
  final PlanStatus status;
  final bool isDark;

  const PlanStatusCard({
    super.key,
    required this.status,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = switch (status) {
      PlanStatus.approved => AppStrings.planStatusApprovedActive.tr(),
      PlanStatus.submitted => AppStrings.planStatusPendingManager.tr(),
      PlanStatus.rejected => AppStrings.planStatusUnderRevision.tr(),
      PlanStatus.closed => AppStrings.closePlan.tr(),
      PlanStatus.draft => AppStrings.createMonthPlan.tr(),
    };

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: status.color.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.planStatus.tr(),
              style: TextStyle(
                fontSize: 12,
                color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              status.label,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: status.color),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
