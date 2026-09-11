import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/create_plan_dialog.dart';

class MonthPlanEmptyState extends StatelessWidget {
  final int month;
  final int year;
  final bool isDark;

  const MonthPlanEmptyState({
    super.key,
    required this.month,
    required this.year,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.calendarDays,
            size: 52,
            color: isDark ? OnyxColors.neutral600 : OnyxColors.neutral400,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noPlanForMonth.tr(args: ['$month', '$year']),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: OnyxColors.primary,
              foregroundColor: OnyxColors.lightCard,
            ),
            icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
            label: Text(AppStrings.createMonthPlan.tr()),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => CreatePlanDialog(month: month, year: year),
              );
            },
          ),
        ],
      ),
    );
  }
}
