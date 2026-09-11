import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_task_item.dart';

class EditPlanTaskDialog extends HookWidget {
  final MonthlyPlanTaskItem item;

  const EditPlanTaskDialog({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final monthPlanCubit = context.monthPlanCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleController = useTextEditingController(text: item.title);
    final moduleController = useTextEditingController(text: item.moduleCode);
    final screenController = useTextEditingController(text: item.screenName);
    final daysController = useTextEditingController(text: item.estimatedDays.toString());
    final hoursController = useTextEditingController(text: item.estimatedHours.toString());
    final descController = useTextEditingController(text: item.description ?? '');

    return AlertDialog(
      backgroundColor: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
      title: Row(
        children: [
          const FaIcon(FontAwesomeIcons.penToSquare, size: 16, color: OnyxColors.primary),
          const SizedBox(width: 10),
          Text(
            AppStrings.editTask.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: AppStrings.taskTitle.tr(),
                  border: const OutlineInputBorder(),
                  isDense: true,
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
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: screenController,
                      decoration: InputDecoration(
                        labelText: AppStrings.screenName.tr(),
                        border: const OutlineInputBorder(),
                        isDense: true,
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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: AppStrings.estDaysCol.tr(),
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (val) {
                        final days = double.tryParse(val) ?? 0.0;
                        hoursController.text = (days * 8.0).toStringAsFixed(1);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: hoursController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: AppStrings.estHoursCol.tr(),
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: AppStrings.description.tr(),
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.safePop(),
          child: Text(AppStrings.cancel.tr()),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: OnyxColors.primary,
            foregroundColor: OnyxColors.white,
          ),
          onPressed: () {
            final days = double.tryParse(daysController.text) ?? item.estimatedDays;
            final hours = double.tryParse(hoursController.text) ?? item.estimatedHours;
            final updatedItem = item.copyWith(
              title: titleController.text.trim(),
              moduleCode: moduleController.text.trim(),
              screenName: screenController.text.trim(),
              estimatedDays: days,
              estimatedHours: hours,
              description: descController.text.trim().isNotEmpty ? descController.text.trim() : null,
            );
            monthPlanCubit.updateTaskInPlan(updatedItem);
            context.safePop();
          },
          child: Text(AppStrings.save.tr()),
        ),
      ],
    );
  }
}
