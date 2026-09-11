import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_task_item.dart';
import 'package:onyx_todo/feature/month_plan/presentation/cubit/month_plan_cubit.dart';
import 'package:onyx_todo/feature/month_plan/presentation/cubit/month_plan_state.dart';
import 'package:onyx_todo/feature/month_plan/presentation/widgets/create_plan_dialog.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_cubit.dart';

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
                    const Icon(Icons.assignment_turned_in_rounded, color: ClickUpColors.primary, size: 28),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.monthlyPlan.tr(),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'نظام خطة الشهر (CRM) - اعتماد ومطابقة ساعات العمل (8h/يوم)',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                          Text('${state.selectedMonth} / ${state.selectedYear}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.chevron_left_rounded, size: 18),
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
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.chevron_right_rounded, size: 18),
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
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.add_rounded, size: 18),
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
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
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
                      ? _buildEmptyState(context, state.selectedMonth, state.selectedYear)
                      : _buildPlanDetails(context, activePlan, currentUser.isDepartmentManager),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, int month, int year) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_note_rounded, size: 64, color: Colors.grey.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text(
            'لا توجد خطة مسجلة لشهر $month / $year',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: ClickUpColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add_rounded),
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
  ) {
    final monthPlanCubit = context.monthPlanCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final targetHours = plan.targetHours;
    final estimatedHours = plan.totalEstimatedHours;
    final actualHours = plan.totalActualHours;
    final completionRate = targetHours > 0 ? (estimatedHours / targetHours) : 0.0;

    return ListView(
      children: [
        // KPI Summary Cards
        Row(
          children: [
            _buildKpiCard(
              'ساعات العمل المستهدفة',
              '${targetHours.toStringAsFixed(0)}h',
              '${plan.workingDays} أيام عمل x 8h',
              Icons.access_time_rounded,
              Colors.blue,
              isDark,
            ),
            const SizedBox(width: 14),
            _buildKpiCard(
              AppStrings.totalEstimatedHours.tr(),
              '${estimatedHours.toStringAsFixed(1)}h',
              'نسبة التغطية: ${(completionRate * 100).toStringAsFixed(0)}%',
              Icons.pending_actions_rounded,
              Colors.orange,
              isDark,
            ),
            const SizedBox(width: 14),
            _buildKpiCard(
              AppStrings.totalActualHours.tr(),
              '${actualHours.toStringAsFixed(1)}h',
              'المنجز الفعلي بنهاية الشهر',
              Icons.done_all_rounded,
              Colors.green,
              isDark,
            ),
            const SizedBox(width: 14),
            _buildStatusCard(plan.status, isDark),
          ],
        ),
        const SizedBox(height: 24),

        // Plan Actions Bar
        Row(
          children: [
            Text(
              'قائمة مهام الخطة (${plan.plannedTasks.length} مهام)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),

            // Add Quick Task to Plan
            OutlinedButton.icon(
              icon: const Icon(Icons.add_task_rounded, size: 16),
              label: const Text('إضافة مهمة للخطة'),
              onPressed: () => _showAddTaskToPlanDialog(context, plan),
            ),
            const SizedBox(width: 10),

            // Submit for approval (Developer action)
            if (plan.status == PlanStatus.draft || plan.status == PlanStatus.rejected)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.send_rounded, size: 16),
                label: Text(AppStrings.submitForApproval.tr()),
                onPressed: () {
                  monthPlanCubit.updatePlanStatus(
                    planId: plan.id,
                    status: PlanStatus.submitted,
                  );
                  context.safeShowSnackBar('تم رفع الخطة لمدير الإدارة للاعتماد');
                },
              ),

            // Approve or Reject (Department Manager actions)
            if (isDepartmentManager && plan.status == PlanStatus.submitted) ...[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                label: Text(AppStrings.approvePlan.tr()),
                onPressed: () {
                  monthPlanCubit.updatePlanStatus(
                    planId: plan.id,
                    status: PlanStatus.approved,
                  );
                  context.safeShowSnackBar('تم اعتماد الخطة بنجاح');
                },
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
                icon: const Icon(Icons.cancel_outlined, size: 16),
                label: Text(AppStrings.rejectPlan.tr()),
                onPressed: () => _showRejectDialog(context, plan),
              ),
            ],

            // Close Month Plan (End of month action)
            if (plan.status == PlanStatus.approved) ...[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.lock_clock_rounded, size: 16),
                label: Text(AppStrings.closePlan.tr()),
                onPressed: () {
                  monthPlanCubit.updatePlanStatus(
                    planId: plan.id,
                    status: PlanStatus.closed,
                  );
                  context.safeShowSnackBar('تم إغلاق خطة الشهر واعتماد الساعات الفعلية');
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
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 140, child: Text('كود المهمة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    SizedBox(width: 80, child: Text('النظام', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    SizedBox(width: 120, child: Text('الشاشة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    Expanded(child: Text('عنوان المهمة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    SizedBox(width: 100, child: Text('الأيام المقدرة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    SizedBox(width: 100, child: Text('ساعات مقدرة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    SizedBox(width: 100, child: Text('ساعات فعلية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Rows
              if (plan.plannedTasks.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'لا توجد مهام مضافة بعد في هذه الخطة',
                      style: TextStyle(color: Colors.grey),
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
                              color: t.actualHours > 0 ? Colors.green : Colors.grey,
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

  Widget _buildKpiCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(PlanStatus status, bool isDark) {
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
            const Text('حالة الخطة', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 10),
            Text(
              status.label,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: status.color),
            ),
            const SizedBox(height: 4),
            Text(
              status == PlanStatus.approved
                  ? 'معتمدة - جاري العمل'
                  : (status == PlanStatus.submitted ? 'بانتظار المدير' : 'قيد التعديل'),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskToPlanDialog(BuildContext context, MonthlyPlanEntity plan) {
    final titleController = TextEditingController();
    final moduleController = TextEditingController(text: 'GLS');
    final screenController = TextEditingController(text: 'قيود اليومية');
    final hoursController = TextEditingController(text: '8.0');
    final daysController = TextEditingController(text: '1.0');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة مهمة لخطة الشهر'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'عنوان المهمة')),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: moduleController, decoration: const InputDecoration(labelText: 'كود النظام (e.g. GLS)'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: screenController, decoration: const InputDecoration(labelText: 'الشاشة'))),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: daysController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الأيام'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: hoursController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الساعات'))),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => ctx.safePop(), child: Text(AppStrings.cancel.tr())),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ClickUpColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                final taskItem = MonthlyPlanTaskItem(
                  taskId: 'pt_${DateTime.now().millisecondsSinceEpoch}',
                  formattedId: 'V5.1.8.${moduleController.text.trim().toUpperCase()}.${(plan.plannedTasks.length + 1).toString().padLeft(6, '0')}',
                  title: titleController.text.trim(),
                  moduleCode: moduleController.text.trim().toUpperCase(),
                  screenName: screenController.text.trim(),
                  estimatedDays: double.tryParse(daysController.text) ?? 1.0,
                  estimatedHours: double.tryParse(hoursController.text) ?? 8.0,
                );
                context.monthPlanCubit.addTaskToPlan(taskItem);
                ctx.safePop();
              }
            },
            child: Text(AppStrings.save.tr()),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, MonthlyPlanEntity plan) {
    final notesController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعادة الخطة للتعديل'),
        content: TextField(
          controller: notesController,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'ملاحظات وتوجيهات المدير للمطور'),
        ),
        actions: [
          TextButton(onPressed: () => ctx.safePop(), child: Text(AppStrings.cancel.tr())),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              context.monthPlanCubit.updatePlanStatus(
                planId: plan.id,
                status: PlanStatus.rejected,
                managerNotes: notesController.text.trim(),
              );
              ctx.safePop();
            },
            child: const Text('إرسال التوجيهات'),
          ),
        ],
      ),
    );
  }
}
