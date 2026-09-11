import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_task_item.dart';

class AddPlanTaskDialog extends HookWidget {
  final MonthlyPlanEntity plan;

  const AddPlanTaskDialog({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final moduleController = useTextEditingController(text: 'GLS');
    final screenController = useTextEditingController(text: AppStrings.dailyEntriesScreen.tr());
    final hoursController = useTextEditingController(text: '8.0');
    final daysController = useTextEditingController(text: '1.0');

    return AlertDialog(
      title: Row(
        children: [
          const FaIcon(FontAwesomeIcons.plus, size: 18, color: ClickUpColors.primary),
          const SizedBox(width: 10),
          Text(AppStrings.addTaskToPlan.tr()),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: AppStrings.taskTitle.tr(),
                prefixIcon: const Center(
                  widthFactor: 1.0,
                  child: FaIcon(FontAwesomeIcons.heading, size: 14, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: moduleController,
                    decoration: InputDecoration(
                      labelText: AppStrings.moduleCodeHint.tr(),
                      prefixIcon: const Center(
                        widthFactor: 1.0,
                        child: FaIcon(FontAwesomeIcons.cubes, size: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: screenController,
                    decoration: InputDecoration(
                      labelText: AppStrings.screenName.tr(),
                      prefixIcon: const Center(
                        widthFactor: 1.0,
                        child: FaIcon(FontAwesomeIcons.desktop, size: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: daysController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppStrings.estDaysCol.tr(),
                      prefixIcon: const Center(
                        widthFactor: 1.0,
                        child: FaIcon(FontAwesomeIcons.calendarDay, size: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: hoursController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: AppStrings.estHoursCol.tr(),
                      prefixIcon: const Center(
                        widthFactor: 1.0,
                        child: FaIcon(FontAwesomeIcons.clock, size: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () => context.safePop(),
          icon: const FaIcon(FontAwesomeIcons.xmark, size: 14),
          label: Text(AppStrings.cancel.tr()),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: ClickUpColors.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (titleController.text.trim().isNotEmpty) {
              final taskItem = MonthlyPlanTaskItem(
                taskId: 'pt_${DateTime.now().millisecondsSinceEpoch}',
                formattedId:
                    'V5.1.8.${moduleController.text.trim().toUpperCase()}.${(plan.plannedTasks.length + 1).toString().padLeft(6, '0')}',
                title: titleController.text.trim(),
                moduleCode: moduleController.text.trim().toUpperCase(),
                screenName: screenController.text.trim(),
                estimatedDays: double.tryParse(daysController.text) ?? 1.0,
                estimatedHours: double.tryParse(hoursController.text) ?? 8.0,
              );
              context.monthPlanCubit.addTaskToPlan(taskItem);
              context.safePop();
            }
          },
          icon: const FaIcon(FontAwesomeIcons.check, size: 14),
          label: Text(AppStrings.save.tr()),
        ),
      ],
    );
  }
}
