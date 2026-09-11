import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_task_item.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';

class ClosePlanDialog extends HookWidget {
  final MonthlyPlanEntity plan;

  const ClosePlanDialog({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final monthPlanCubit = context.monthPlanCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final rolloverUnfinished = useState(true);
    final isSubmitting = useState(false);

    // Prepare controllers for each task
    final actualHoursControllers = useMemoized(
      () => plan.plannedTasks.map((t) {
        final initial = t.actualHours > 0 ? t.actualHours : t.estimatedHours;
        return TextEditingController(text: initial.toStringAsFixed(1));
      }).toList(),
      [plan.plannedTasks],
    );

    final logicDeliveredControllers = useMemoized(
      () => plan.plannedTasks.map((t) {
        return TextEditingController(text: t.logicDelivered ?? '');
      }).toList(),
      [plan.plannedTasks],
    );

    useEffect(() {
      return () {
        for (final c in actualHoursControllers) {
          c.dispose();
        }
        for (final c in logicDeliveredControllers) {
          c.dispose();
        }
      };
    }, const []);

    return Dialog(
      backgroundColor: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 680,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.lock, color: OnyxColors.purple, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.closePlan.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${plan.developerName} • ${plan.month}/${plan.year} • ${plan.plannedTasks.length} ${AppStrings.tasks.tr()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.xmark,
                    size: 16,
                    color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
                  ),
                  onPressed: () => context.safePop(),
                ),
              ],
            ),
            const Divider(height: 24),

            // Rollover Option Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: OnyxColors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: OnyxColors.purple.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: rolloverUnfinished.value,
                    activeColor: OnyxColors.purple,
                    onChanged: (val) => rolloverUnfinished.value = val ?? true,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppStrings.rolloverUnfinishedTasks.tr(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tasks List
            Expanded(
              child: ListView.separated(
                itemCount: plan.plannedTasks.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final task = plan.plannedTasks[index];
                  final hoursCtrl = actualHoursControllers[index];
                  final logicCtrl = logicDeliveredControllers[index];

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? OnyxColors.darkBackground : OnyxColors.neutral50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TaskIdBadge(formattedId: task.formattedId),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: OnyxColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                task.moduleCode,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: OnyxColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                task.title,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${AppStrings.estimatedHours.tr()}: ${task.estimatedHours}h',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Actual Hours Input
                            SizedBox(
                              width: 140,
                              child: TextField(
                                controller: hoursCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(
                                  labelText: AppStrings.actHoursCol.tr(),
                                  suffixText: 'h',
                                  isDense: true,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Logic Delivered Input
                            Expanded(
                              child: TextField(
                                controller: logicCtrl,
                                decoration: InputDecoration(
                                  labelText: AppStrings.logicDelivered.tr(),
                                  hintText: 'e.g. Completed screen logic, integration, API...',
                                  isDense: true,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: isSubmitting.value ? null : () => context.safePop(),
                  child: Text(AppStrings.cancel.tr()),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OnyxColors.purple,
                    foregroundColor: OnyxColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: isSubmitting.value
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const FaIcon(FontAwesomeIcons.lock, size: 14),
                  label: Text(
                    AppStrings.closePlan.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: isSubmitting.value
                      ? null
                      : () async {
                          isSubmitting.value = true;
                          try {
                            final updatedTasks = <MonthlyPlanTaskItem>[];
                            for (var i = 0; i < plan.plannedTasks.length; i++) {
                              final original = plan.plannedTasks[i];
                              final actH = double.tryParse(actualHoursControllers[i].text) ?? original.estimatedHours;
                              final logDelivered = logicDeliveredControllers[i].text.trim();
                              updatedTasks.add(
                                original.copyWith(
                                  actualHours: actH,
                                  logicDelivered: logDelivered.isNotEmpty ? logDelivered : null,
                                ),
                              );
                            }

                            await monthPlanCubit.closePlanWithRollover(
                              plan: plan,
                              tasksWithActuals: updatedTasks,
                              rolloverUnfinished: rolloverUnfinished.value,
                            );

                            if (!context.mounted) return;
                            context.safeShowSnackBar(
                              SnackBar(
                                content: Text(AppStrings.planClosedToast.tr()),
                                backgroundColor: OnyxColors.purple,
                              ),
                            );
                            context.safePop();
                          } catch (e) {
                            isSubmitting.value = false;
                          }
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
