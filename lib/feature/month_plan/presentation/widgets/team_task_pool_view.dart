import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_task_item.dart';
import 'package:onyx_todo/feature/task/presentation/cubit/tasks_cubit.dart';
import 'package:onyx_todo/feature/task/presentation/cubit/tasks_state.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/clickup_status_ring.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';
import 'package:onyx_todo/feature/workspace/domain/entities/onyx_module.dart';

class TeamTaskPoolView extends HookWidget {
  final MonthlyPlanEntity? activePlan;
  final bool isDark;

  const TeamTaskPoolView({
    super.key,
    required this.activePlan,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final workspaceCubit = context.workspaceCubit;
    final monthPlanCubit = context.monthPlanCubit;
    final modules = workspaceCubit.state.modulesState.data ?? OnyxModule.standardModules;

    final searchQuery = useState('');
    final selectedModule = useState<String?>(null);
    final selectedTaskIds = useState<Set<String>>({});

    final existingTaskIds = useMemoized(() {
      return activePlan?.plannedTasks.map((t) => t.taskId).toSet() ?? <String>{};
    }, [activePlan?.plannedTasks]);

    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        final allTasks = state.tasksState.data ?? [];

        // Filter pool tasks
        final filteredTasks = allTasks.where((t) {
          if (searchQuery.value.isNotEmpty) {
            final q = searchQuery.value.toLowerCase();
            final matchId = t.formattedId.toLowerCase().contains(q);
            final matchTitle = t.title.toLowerCase().contains(q);
            final matchScreen = t.screenName.toLowerCase().contains(q);
            if (!matchId && !matchTitle && !matchScreen) return false;
          }
          if (selectedModule.value != null && t.moduleCode != selectedModule.value) {
            return false;
          }
          return true;
        }).toList();

        final selectableTasks = filteredTasks.where((t) => !existingTaskIds.contains(t.id)).toList();
        final allSelected = selectableTasks.isNotEmpty &&
            selectableTasks.every((t) => selectedTaskIds.value.contains(t.id));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toolbar: Search, Module Filter & Add Button
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  // Fast Search Box
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: AppStrings.searchTeamPoolHint.tr(),
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: isDark ? OnyxColors.neutral500 : OnyxColors.neutral400,
                        ),
                        prefixIcon: const Icon(Icons.search, size: 18),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        isDense: true,
                      ),
                      onChanged: (val) => searchQuery.value = val,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Module Selector Dropdown
                  DropdownButton<String?>(
                    value: selectedModule.value,
                    hint: Text(
                      AppStrings.filterByModule.tr(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    underline: const SizedBox(),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(AppStrings.allModules.tr(), style: const TextStyle(fontSize: 12)),
                      ),
                      ...modules.map((m) {
                        return DropdownMenuItem<String?>(
                          value: m.code,
                          child: Text('${m.code} - ${m.nameEn}', style: const TextStyle(fontSize: 12)),
                        );
                      }),
                    ],
                    onChanged: (val) => selectedModule.value = val,
                  ),
                  const Spacer(),

                  // Select All / Deselect All Toggle
                  if (selectableTasks.isNotEmpty)
                    TextButton.icon(
                      icon: Icon(
                        allSelected ? Icons.check_box : Icons.check_box_outline_blank,
                        size: 16,
                        color: OnyxColors.primary,
                      ),
                      label: Text(
                        allSelected ? 'إلغاء التحديد' : 'تحديد الكل',
                        style: const TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        if (allSelected) {
                          selectedTaskIds.value = {};
                        } else {
                          selectedTaskIds.value = selectableTasks.map((t) => t.id).toSet();
                        }
                      },
                    ),
                  const SizedBox(width: 10),

                  // Add Selected to My Plan Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnyxColors.primary,
                      foregroundColor: OnyxColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    icon: const FaIcon(FontAwesomeIcons.circlePlus, size: 13),
                    label: Text(
                      selectedTaskIds.value.isEmpty
                          ? AppStrings.addSelectedToPlan.tr()
                          : '${AppStrings.addSelectedToPlan.tr()} (${selectedTaskIds.value.length})',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    onPressed: activePlan == null || selectedTaskIds.value.isEmpty
                        ? null
                        : () {
                            final tasksToAdd = allTasks
                                .where((t) => selectedTaskIds.value.contains(t.id))
                                .map((t) => MonthlyPlanTaskItem(
                                      taskId: t.id,
                                      formattedId: t.formattedId,
                                      title: t.title,
                                      moduleCode: t.moduleCode,
                                      screenName: t.screenName,
                                      estimatedDays: (t.estimatedHours / 8.0).clamp(0.5, 30.0),
                                      estimatedHours: t.estimatedHours > 0 ? t.estimatedHours : 8.0,
                                      actualHours: t.actualHours,
                                      status: t.status.value,
                                    ))
                                .toList();

                            final currentPlanned = List<MonthlyPlanTaskItem>.from(activePlan!.plannedTasks);
                            currentPlanned.addAll(tasksToAdd);

                            final newTotalHours = currentPlanned.fold<double>(
                              0.0,
                              (sum, item) => sum + item.estimatedHours,
                            );

                            final updatedPlan = activePlan!.copyWith(
                              plannedTasks: currentPlanned,
                              totalEstimatedHours: newTotalHours,
                            );

                            monthPlanCubit.saveOrUpdatePlan(updatedPlan);
                            selectedTaskIds.value = {};

                            context.safeShowSnackBar(
                              SnackBar(
                                content: Text(AppStrings.tasksAddedToPlan.tr()),
                                backgroundColor: OnyxColors.success,
                              ),
                            );
                          },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Tasks List
            Expanded(
              child: filteredTasks.isEmpty
                  ? Center(
                      child: Text(
                        AppStrings.noTasksFound.tr(),
                        style: TextStyle(
                          color: isDark ? OnyxColors.neutral500 : OnyxColors.neutral400,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                        ),
                      ),
                      child: ListView.separated(
                        itemCount: filteredTasks.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                        ),
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          final isInPlan = existingTaskIds.contains(task.id);
                          final isSelected = selectedTaskIds.value.contains(task.id);

                          return Container(
                            color: isSelected ? OnyxColors.primary.withValues(alpha: 0.08) : Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            child: Row(
                              children: [
                                // Checkbox or In-Plan indicator
                                if (isInPlan)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: OnyxColors.success.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'في الخطة',
                                      style: TextStyle(fontSize: 10, color: OnyxColors.success, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                else
                                  Checkbox(
                                    value: isSelected,
                                    activeColor: OnyxColors.primary,
                                    onChanged: (val) {
                                      final current = Set<String>.from(selectedTaskIds.value);
                                      if (val == true) {
                                        current.add(task.id);
                                      } else {
                                        current.remove(task.id);
                                      }
                                      selectedTaskIds.value = current;
                                    },
                                  ),
                                const SizedBox(width: 8),

                                // Status Ring
                                ClickUpStatusRing(status: task.status, size: 14),
                                const SizedBox(width: 10),

                                // Formatted ID
                                TaskIdBadge(formattedId: task.formattedId),
                                const SizedBox(width: 10),

                                // Module Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isDark ? OnyxColors.neutral800 : OnyxColors.neutral200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    task.moduleCode,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // Screen Name
                                Text(
                                  task.screenName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Title
                                Expanded(
                                  child: Text(
                                    task.title,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Priority
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: task.priority.color.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    task.priority.label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: task.priority.color,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Estimated Hours
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isDark ? OnyxColors.neutral800 : OnyxColors.neutral100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${task.estimatedHours > 0 ? task.estimatedHours.toStringAsFixed(0) : '8'}h',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
