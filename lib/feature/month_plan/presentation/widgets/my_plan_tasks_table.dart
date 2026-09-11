import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_task_item.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';

class MyPlanTasksTable extends StatelessWidget {
  final MonthlyPlanEntity plan;
  final bool isDark;

  const MyPlanTasksTable({
    super.key,
    required this.plan,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final monthPlanCubit = context.monthPlanCubit;
    final canEdit = plan.status == PlanStatus.draft || plan.status == PlanStatus.rejected;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? OnyxColors.neutral800 : OnyxColors.neutral100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: [
                SizedBox(width: 140, child: Text(AppStrings.taskIdCol.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                SizedBox(width: 80, child: Text(AppStrings.moduleCol.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                SizedBox(width: 120, child: Text(AppStrings.screenCol.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(child: Text(AppStrings.titleCol.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                SizedBox(width: 90, child: Text(AppStrings.estDaysCol.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                SizedBox(width: 90, child: Text(AppStrings.estHoursCol.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                SizedBox(width: 90, child: Text(AppStrings.actHoursCol.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                if (canEdit) const SizedBox(width: 40),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
          ),

          // Table Rows
          if (plan.plannedTasks.isEmpty)
            Padding(
              padding: const EdgeInsets.all(36),
              child: Center(
                child: Text(
                  AppStrings.noTasksInPlan.tr(),
                  style: TextStyle(
                    color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
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
                      color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 140, child: TaskIdBadge(formattedId: t.formattedId)),
                    SizedBox(width: 80, child: Text(t.moduleCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
                    SizedBox(width: 120, child: Text(t.screenName, style: const TextStyle(fontSize: 12))),
                    Expanded(
                      child: Text(
                        t.title,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 90, child: Text('${t.estimatedDays}d', style: const TextStyle(fontSize: 12))),
                    SizedBox(width: 90, child: Text('${t.estimatedHours}h', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    SizedBox(
                      width: 90,
                      child: Text(
                        '${t.actualHours}h',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: t.actualHours > 0 ? OnyxColors.success : (isDark ? OnyxColors.neutral400 : OnyxColors.neutral500),
                        ),
                      ),
                    ),
                    if (canEdit)
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.trashCan, size: 13, color: OnyxColors.danger),
                          onPressed: () {
                            final updatedTasks = List<MonthlyPlanTaskItem>.from(plan.plannedTasks)
                              ..removeWhere((item) => item.taskId == t.taskId);

                            final newTotalHours = updatedTasks.fold<double>(
                              0.0,
                              (sum, item) => sum + item.estimatedHours,
                            );

                            final updatedPlan = plan.copyWith(
                              plannedTasks: updatedTasks,
                              totalEstimatedHours: newTotalHours,
                            );

                            monthPlanCubit.saveOrUpdatePlan(updatedPlan);
                          },
                        ),
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
