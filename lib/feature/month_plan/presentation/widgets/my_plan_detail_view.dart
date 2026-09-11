import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/add_plan_task_dialog.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/close_plan_dialog.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/monthly_hours_counter_card.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/my_plan_tasks_table.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/plan_kpi_card.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/plan_status_card.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/reject_plan_dialog.dart';

class MyPlanDetailView extends StatelessWidget {
  final MonthlyPlanEntity plan;
  final bool isDepartmentManager;
  final bool isDark;

  const MyPlanDetailView({
    super.key,
    required this.plan,
    required this.isDepartmentManager,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final monthPlanCubit = context.monthPlanCubit;

    final targetHours = plan.targetHours > 0 ? plan.targetHours : (plan.workingDays * 8.0);
    final estimatedHours = plan.plannedTasks.fold<double>(0.0, (sum, t) => sum + t.estimatedHours);
    final actualHours = plan.totalActualHours;
    final completionRate = targetHours > 0 ? (estimatedHours / targetHours) : 0.0;

    return ListView(
      children: [
        // Real-time dynamic hours counter (8h/day working days)
        MonthlyHoursCounterCard(plan: plan, isDark: isDark),
        const SizedBox(height: 16),

        // KPI Summary Cards
        Row(
          children: [
            PlanKpiCard(
              title: AppStrings.targetWorkHours.tr(),
              value: '${targetHours.toStringAsFixed(0)}h',
              subtitle: '${plan.workingDays} ${AppStrings.workingDaysCount.tr()}',
              icon: FontAwesomeIcons.clock,
              color: OnyxColors.info,
              isDark: isDark,
            ),
            const SizedBox(width: 14),
            PlanKpiCard(
              title: AppStrings.totalEstimatedHours.tr(),
              value: '${estimatedHours.toStringAsFixed(1)}h',
              subtitle: '${AppStrings.coveragePercentage.tr()}: ${(completionRate * 100).toStringAsFixed(0)}%',
              icon: FontAwesomeIcons.hourglassHalf,
              color: OnyxColors.warning,
              isDark: isDark,
            ),
            const SizedBox(width: 14),
            PlanKpiCard(
              title: AppStrings.totalActualHours.tr(),
              value: '${actualHours.toStringAsFixed(1)}h',
              subtitle: AppStrings.endOfMonthActual.tr(),
              icon: FontAwesomeIcons.checkDouble,
              color: OnyxColors.success,
              isDark: isDark,
            ),
            const SizedBox(width: 14),
            PlanStatusCard(status: plan.status, isDark: isDark),
          ],
        ),
        const SizedBox(height: 20),

        // Plan Actions Bar
        Row(
          children: [
            Text(
              '${AppStrings.planTasksCount.tr()} (${plan.plannedTasks.length})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
              ),
            ),
            const Spacer(),

            // Add Quick Task to Plan
            OutlinedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.plus, size: 12),
              label: Text(AppStrings.addTaskToPlan.tr()),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AddPlanTaskDialog(plan: plan),
                );
              },
            ),
            const SizedBox(width: 10),

            // Submit for approval (Developer action)
            if (plan.status == PlanStatus.draft || plan.status == PlanStatus.rejected)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: OnyxColors.primary,
                  foregroundColor: OnyxColors.lightCard,
                ),
                icon: const FaIcon(FontAwesomeIcons.paperPlane, size: 13),
                label: Text(AppStrings.submitForApproval.tr()),
                onPressed: () {
                  monthPlanCubit.updatePlanStatus(
                    planId: plan.id,
                    status: PlanStatus.submitted,
                  );
                  context.safeShowSnackBar(
                    SnackBar(content: Text(AppStrings.planSubmittedToast.tr())),
                  );
                },
              ),

            // Approve or Reject (Department Manager actions)
            if (isDepartmentManager && plan.status == PlanStatus.submitted) ...[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: OnyxColors.success,
                  foregroundColor: OnyxColors.lightCard,
                ),
                icon: const FaIcon(FontAwesomeIcons.circleCheck, size: 13),
                label: Text(AppStrings.approvePlan.tr()),
                onPressed: () {
                  monthPlanCubit.updatePlanStatus(
                    planId: plan.id,
                    status: PlanStatus.approved,
                  );
                  context.safeShowSnackBar(
                    SnackBar(content: Text(AppStrings.planApprovedToast.tr())),
                  );
                },
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: OnyxColors.danger,
                  side: const BorderSide(color: OnyxColors.danger),
                ),
                icon: const FaIcon(FontAwesomeIcons.circleXmark, size: 13),
                label: Text(AppStrings.rejectPlan.tr()),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => RejectPlanDialog(plan: plan),
                  );
                },
              ),
            ],

            // Close Month Plan (End of month action)
            if (plan.status == PlanStatus.approved) ...[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: OnyxColors.purple,
                  foregroundColor: OnyxColors.lightCard,
                ),
                icon: const FaIcon(FontAwesomeIcons.lock, size: 13),
                label: Text(AppStrings.closePlan.tr()),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => ClosePlanDialog(plan: plan),
                  );
                },
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),

        // Tasks Table
        MyPlanTasksTable(plan: plan, isDark: isDark),
      ],
    );
  }
}
