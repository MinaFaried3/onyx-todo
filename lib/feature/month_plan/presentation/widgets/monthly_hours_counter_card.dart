import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';

class MonthlyHoursCounterCard extends StatelessWidget {
  final MonthlyPlanEntity plan;
  final bool isDark;

  const MonthlyHoursCounterCard({
    super.key,
    required this.plan,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final target = plan.targetHours > 0 ? plan.targetHours : (plan.workingDays * 8.0);
    final registered = plan.plannedTasks.fold<double>(
      0.0,
      (sum, item) => sum + item.estimatedHours,
    );
    final diff = registered - target;
    final ratio = target > 0 ? (registered / target).clamp(0.0, 1.5) : 0.0;

    final Color statusColor;
    final String statusText;
    final FaIconData statusIcon;

    if (diff.abs() < 4.0) {
      statusColor = OnyxColors.success;
      statusText = 'مكتمل / On Target';
      statusIcon = FontAwesomeIcons.circleCheck;
    } else if (diff < 0) {
      statusColor = OnyxColors.warning;
      statusText = '${AppStrings.remainingHours.tr()}: ${diff.abs().toStringAsFixed(1)}h';
      statusIcon = FontAwesomeIcons.triangleExclamation;
    } else {
      statusColor = OnyxColors.info;
      statusText = '${AppStrings.extraHours.tr()}: +${diff.toStringAsFixed(1)}h';
      statusIcon = FontAwesomeIcons.arrowTrendUp;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: OnyxColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const FaIcon(FontAwesomeIcons.calculator, color: OnyxColors.primary, size: 16),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.monthlyHoursCounter.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    '${plan.workingDays} ${AppStrings.workingDaysCount.tr()} × 8.0h = ${target.toStringAsFixed(0)}h',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Status Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(statusIcon, size: 11, color: statusColor),
                    const SizedBox(width: 6),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Numbers Summary Row
          Row(
            children: [
              _buildMetric(
                label: AppStrings.calculatedWorkHours.tr(),
                value: '${target.toStringAsFixed(0)}h',
                color: isDark ? OnyxColors.neutral200 : OnyxColors.neutral800,
              ),
              const SizedBox(width: 24),
              _buildMetric(
                label: AppStrings.registeredHours.tr(),
                value: '${registered.toStringAsFixed(1)}h',
                color: OnyxColors.primary,
              ),
              const SizedBox(width: 24),
              _buildMetric(
                label: AppStrings.coveragePercentage.tr(),
                value: '${(ratio * 100).toStringAsFixed(0)}%',
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Dynamic Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (ratio / 1.2).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: isDark ? OnyxColors.neutral800 : OnyxColors.neutral200,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
