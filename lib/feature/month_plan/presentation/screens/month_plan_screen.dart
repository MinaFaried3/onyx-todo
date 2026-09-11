import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';
import 'package:onyx_todo/feature/month_plan/presentation/cubit/month_plan_cubit.dart';
import 'package:onyx_todo/feature/month_plan/presentation/cubit/month_plan_state.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/add_plan_task_dialog.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/create_plan_dialog.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/plan_kpi_card.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/plan_status_card.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/reject_plan_dialog.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';

class MonthPlanScreen extends HookWidget {
  const MonthPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final monthPlanCubit = context.monthPlanCubit;
    final workspaceCubit = context.workspaceCubit;
    final currentUser = workspaceCubit.state.currentUser;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    useEffect(() {
      monthPlanCubit.fetchPlans(
        developerName: currentUser.isDepartmentManager ? null : currentUser.name,
      );
      return null;
    }, [currentUser.id]);

    return BlocBuilder<MonthPlanCubit, MonthPlanState>(
      builder: (context, state) {
        final plans = state.plansState.data ?? [];
        final activePlan = state.activePlanState.data;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Bar
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.calendarCheck, color: ClickUpColors.primary, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.monthlyPlan.tr(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          AppStrings.crmSystemTitle.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? ClickUpColors.neutral400 : ClickUpColors.neutral500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Month & Year Selector
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${state.selectedMonth} / ${state.selectedYear}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 12),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              final prevMonth = state.selectedMonth == 1 ? 12 : state.selectedMonth - 1;
                              final prevYear = state.selectedMonth == 1 ? state.selectedYear - 1 : state.selectedYear;
                              monthPlanCubit.selectMonthYear(
                                month: prevMonth,
                                year: prevYear,
                                developerName: currentUser.isDepartmentManager ? null : currentUser.name,
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const FaIcon(FontAwesomeIcons.chevronRight, size: 12),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              final nextMonth = state.selectedMonth == 12 ? 1 : state.selectedMonth + 1;
                              final nextYear = state.selectedMonth == 12 ? state.selectedYear + 1 : state.selectedYear;
                              monthPlanCubit.selectMonthYear(
                                month: nextMonth,
                                year: nextYear,
                                developerName: currentUser.isDepartmentManager ? null : currentUser.name,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // New Plan Button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ClickUpColors.primary,
                        foregroundColor: ClickUpColors.lightCard,
                      ),
                      icon: const FaIcon(FontAwesomeIcons.plus, size: 13),
                      label: Text(AppStrings.createMonthPlan.tr()),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => CreatePlanDialog(
                            month: state.selectedMonth,
                            year: state.selectedYear,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Department Manager: Plans List Tabs / Switcher
                if (currentUser.isDepartmentManager && plans.isNotEmpty) ...[
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: plans.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final p = plans[index];
                        final isSelected = activePlan?.id == p.id;
                        return ChoiceChip(
                          label: Text('${p.developerName} (${p.status.label})'),
                          selected: isSelected,
                          selectedColor: ClickUpColors.primary.withValues(alpha: 0.2),
                          onSelected: (_) {
                            monthPlanCubit.saveOrUpdatePlan(p);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Content Area
                Expanded(
                  child: activePlan == null
                      ? _buildEmptyState(context, state.selectedMonth, state.selectedYear, isDark)
                      : _buildPlanDetails(context, activePlan, currentUser.isDepartmentManager, isDark),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, int month, int year, bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.calendarDays,
            size: 52,
            color: isDark ? ClickUpColors.neutral600 : ClickUpColors.neutral400,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noPlanForMonth.tr(args: ['$month', '$year']),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? ClickUpColors.neutral400 : ClickUpColors.neutral500,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: ClickUpColors.primary,
              foregroundColor: ClickUpColors.lightCard,
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

  Widget _buildPlanDetails(
    BuildContext context,
    MonthlyPlanEntity plan,
    bool isDepartmentManager,
    bool isDark,
  ) {
    final monthPlanCubit = context.monthPlanCubit;

    final targetHours = plan.targetHours;
    final estimatedHours = plan.totalEstimatedHours;
    final actualHours = plan.totalActualHours;
    final completionRate = targetHours > 0 ? (estimatedHours / targetHours) : 0.0;

    return ListView(
      children: [
        // KPI Summary Cards
        Row(
          children: [
            PlanKpiCard(
              title: AppStrings.targetWorkHours.tr(),
              value: '${targetHours.toStringAsFixed(0)}h',
              subtitle: '${plan.workingDays} ${AppStrings.workingDaysCount.tr()}',
              icon: FontAwesomeIcons.clock,
              color: ClickUpColors.info,
              isDark: isDark,
            ),
            const SizedBox(width: 14),
            PlanKpiCard(
              title: AppStrings.totalEstimatedHours.tr(),
              value: '${estimatedHours.toStringAsFixed(1)}h',
              subtitle: '${AppStrings.coveragePercentage.tr()}: ${(completionRate * 100).toStringAsFixed(0)}%',
              icon: FontAwesomeIcons.hourglassHalf,
              color: ClickUpColors.warning,
              isDark: isDark,
            ),
            const SizedBox(width: 14),
            PlanKpiCard(
              title: AppStrings.totalActualHours.tr(),
              value: '${actualHours.toStringAsFixed(1)}h',
              subtitle: AppStrings.endOfMonthActual.tr(),
              icon: FontAwesomeIcons.checkDouble,
              color: ClickUpColors.success,
              isDark: isDark,
            ),
            const SizedBox(width: 14),
            PlanStatusCard(status: plan.status, isDark: isDark),
          ],
        ),
        const SizedBox(height: 24),

        // Plan Actions Bar
        Row(
          children: [
            Text(
              '${AppStrings.planTasksCount.tr()} (${plan.plannedTasks.length})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
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
                  backgroundColor: ClickUpColors.primary,
                  foregroundColor: ClickUpColors.lightCard,
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
                  backgroundColor: ClickUpColors.success,
                  foregroundColor: ClickUpColors.lightCard,
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
                  foregroundColor: ClickUpColors.danger,
                  side: const BorderSide(color: ClickUpColors.danger),
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
                  backgroundColor: ClickUpColors.purple,
                  foregroundColor: ClickUpColors.lightCard,
                ),
                icon: const FaIcon(FontAwesomeIcons.lock, size: 13),
                label: Text(AppStrings.closePlan.tr()),
                onPressed: () {
                  monthPlanCubit.updatePlanStatus(
                    planId: plan.id,
                    status: PlanStatus.closed,
                  );
                  context.safeShowSnackBar(
                    SnackBar(content: Text(AppStrings.planClosedToast.tr())),
                  );
                },
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),

        // Tasks Table
        Container(
          decoration: BoxDecoration(
            color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
            ),
          ),
          child: Column(
            children: [
              // Header Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? ClickUpColors.neutral800 : ClickUpColors.neutral100,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 140, child: Text(AppStrings.taskIdCol.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    SizedBox(width: 80, child: Text(AppStrings.moduleCol.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    SizedBox(width: 120, child: Text(AppStrings.screenCol.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    Expanded(child: Text(AppStrings.titleCol.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    SizedBox(width: 100, child: Text(AppStrings.estDaysCol.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    SizedBox(width: 100, child: Text(AppStrings.estHoursCol.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    SizedBox(width: 100, child: Text(AppStrings.actHoursCol.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
              ),

              // Rows
              if (plan.plannedTasks.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      AppStrings.noTasksInPlan.tr(),
                      style: TextStyle(
                        color: isDark ? ClickUpColors.neutral400 : ClickUpColors.neutral500,
                      ),
                    ),
                  ),
                )
              else
                ...plan.plannedTasks.map((t) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 140, child: TaskIdBadge(formattedId: t.formattedId)),
                        SizedBox(width: 80, child: Text(t.moduleCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                        SizedBox(width: 120, child: Text(t.screenName, style: const TextStyle(fontSize: 12))),
                        Expanded(child: Text(t.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                        SizedBox(width: 100, child: Text('${t.estimatedDays}d', style: const TextStyle(fontSize: 12))),
                        SizedBox(width: 100, child: Text('${t.estimatedHours}h', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        SizedBox(
                          width: 100,
                          child: Text(
                            '${t.actualHours}h',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: t.actualHours > 0 ? ClickUpColors.success : (isDark ? ClickUpColors.neutral400 : ClickUpColors.neutral500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }
}
