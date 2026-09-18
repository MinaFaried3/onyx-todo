import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/core/ui/responsive/responsive_extension.dart';
import 'package:onyx_todo/feature/month_plan/presentation/cubit/month_plan_cubit.dart';
import 'package:onyx_todo/feature/month_plan/presentation/cubit/month_plan_state.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/create_plan_dialog.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/month_plan_empty_state.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/my_plan_detail_view.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/team_task_pool_view.dart';

class MonthPlanScreen extends HookWidget {
  const MonthPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final monthPlanCubit = context.monthPlanCubit;
    final workspaceCubit = context.workspaceCubit;
    final currentUser = workspaceCubit.state.currentUser;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = context.isMobile;

    final selectedTab = useState(0); // 0: My Plan, 1: Team Task Pool

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
            padding: EdgeInsets.all(isMobile ? 12 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Bar
                if (isMobile) ...[
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.calendarCheck, color: OnyxColors.primary, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppStrings.monthlyPlan.tr(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Month & Year Selector
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                              Text(
                                '${state.selectedMonth} / ${state.selectedYear}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
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
                      ),
                      const SizedBox(width: 8),

                      // New Plan Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: OnyxColors.primary,
                          foregroundColor: OnyxColors.lightCard,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.plus, size: 12),
                        label: Text(AppStrings.createMonthPlan.tr(), style: const TextStyle(fontSize: 12)),
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
                ] else ...[
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.calendarCheck, color: OnyxColors.primary, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.monthlyPlan.tr(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                              ),
                            ),
                            Text(
                              AppStrings.crmSystemTitle.tr(),
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Month & Year Selector
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
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
                          backgroundColor: OnyxColors.primary,
                          foregroundColor: OnyxColors.lightCard,
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
                ],
                const SizedBox(height: 16),

                // Tab Switcher: "خطة الشهر الخاصة بي" vs "مجمع مهام الفريق"
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(FontAwesomeIcons.listCheck, size: 12),
                          const SizedBox(width: 6),
                          Text(AppStrings.myMonthlyPlan.tr()),
                        ],
                      ),
                      selected: selectedTab.value == 0,
                      selectedColor: OnyxColors.primary.withValues(alpha: 0.18),
                      labelStyle: TextStyle(
                        fontWeight: selectedTab.value == 0 ? FontWeight.bold : FontWeight.normal,
                        color: selectedTab.value == 0
                            ? OnyxColors.primary
                            : (isDark ? OnyxColors.neutral300 : OnyxColors.neutral700),
                      ),
                      onSelected: (_) => selectedTab.value = 0,
                    ),
                    ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(FontAwesomeIcons.boxesStacked, size: 12),
                          const SizedBox(width: 6),
                          Text(AppStrings.teamTaskPool.tr()),
                        ],
                      ),
                      selected: selectedTab.value == 1,
                      selectedColor: OnyxColors.primary.withValues(alpha: 0.18),
                      labelStyle: TextStyle(
                        fontWeight: selectedTab.value == 1 ? FontWeight.bold : FontWeight.normal,
                        color: selectedTab.value == 1
                            ? OnyxColors.primary
                            : (isDark ? OnyxColors.neutral300 : OnyxColors.neutral700),
                      ),
                      onSelected: (_) => selectedTab.value = 1,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Department Manager: Plans List Tabs / Switcher
                if (currentUser.isDepartmentManager && plans.isNotEmpty && selectedTab.value == 0) ...[
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
                          selectedColor: OnyxColors.primary.withValues(alpha: 0.2),
                          onSelected: (_) {
                            monthPlanCubit.saveOrUpdatePlan(p);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Content Area: Tab 0 (My Plan) or Tab 1 (Team Task Pool)
                Expanded(
                  child: selectedTab.value == 0
                      ? (activePlan == null
                          ? MonthPlanEmptyState(
                              month: state.selectedMonth,
                              year: state.selectedYear,
                              isDark: isDark,
                            )
                          : MyPlanDetailView(
                              plan: activePlan,
                              isDepartmentManager: currentUser.isDepartmentManager,
                              isDark: isDark,
                            ))
                      : TeamTaskPoolView(
                          activePlan: activePlan,
                          isDark: isDark,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
