import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';

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
    String subtitle;
    switch (status) {
      case PlanStatus.approved:
        subtitle = AppStrings.approvedWorking.tr();
      case PlanStatus.submitted:
        subtitle = AppStrings.waitingManagerApproval.tr();
      case PlanStatus.rejected:
        subtitle = AppStrings.underRevision.tr();
      case PlanStatus.closed:
        subtitle = AppStrings.planClosed.tr();
      case PlanStatus.draft:
        subtitle = AppStrings.draftPlan.tr();
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
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
                color: isDark ? ClickUpColors.neutral400 : ClickUpColors.neutral500,
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
                color: isDark ? ClickUpColors.neutral400 : ClickUpColors.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
