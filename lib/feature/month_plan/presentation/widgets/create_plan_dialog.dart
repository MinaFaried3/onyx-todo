import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';

class CreatePlanDialog extends HookWidget {
  final int month;
  final int year;

  const CreatePlanDialog({
    super.key,
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    final monthPlanCubit = context.monthPlanCubit;
    final workspaceCubit = context.workspaceCubit;
    final currentUser = workspaceCubit.state.currentUser;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final workingDaysController = useTextEditingController(text: '20');
    final targetHoursController = useTextEditingController(text: '160.0');

    return Dialog(
      backgroundColor: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month_rounded, color: ClickUpColors.primary),
                const SizedBox(width: 8),
                Text(
                  AppStrings.createMonthPlan.tr(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => context.safePop(),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              'المطور: ${currentUser.name} (${currentUser.stack.label})',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Text(
              'شهر: $month / $year',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: workingDaysController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'أيام العمل',
                      suffixText: 'يوم',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      final days = double.tryParse(val) ?? 0.0;
                      targetHoursController.text = (days * 8.0).toStringAsFixed(1);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: targetHoursController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppStrings.targetHours.tr(),
                      suffixText: 'h',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => context.safePop(),
                  child: Text(AppStrings.cancel.tr()),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ClickUpColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final days = int.tryParse(workingDaysController.text.trim()) ?? 20;
                    final target = double.tryParse(targetHoursController.text.trim()) ?? 160.0;

                    final newPlan = MonthlyPlanEntity(
                      id: '${year}_${month}_${currentUser.id}',
                      developerName: currentUser.name,
                      developerStack: currentUser.stack,
                      month: month,
                      year: year,
                      workingDays: days,
                      targetHours: target,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    monthPlanCubit.saveOrUpdatePlan(newPlan);
                    context.safePop();
                  },
                  child: Text(AppStrings.save.tr()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
