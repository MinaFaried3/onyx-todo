import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/achievement/domain/entities/achievement_task_item.dart';
import 'package:onyx_todo/feature/achievement/domain/entities/daily_achievement_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';

class LogAchievementDialog extends HookWidget {
  const LogAchievementDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final achievementCubit = context.achievementCubit;
    final workspaceCubit = context.workspaceCubit;
    final currentUser = workspaceCubit.state.currentUser;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final taskIdController = useTextEditingController();
    final taskTitleController = useTextEditingController();
    final moduleController = useTextEditingController(text: 'GLS');
    final screenController = useTextEditingController(text: 'قيود اليومية');
    final hoursController = useTextEditingController(text: '4.0');
    final blockersController = useTextEditingController();
    final nextDayPlanController = useTextEditingController();

    final tasksList = useState<List<AchievementTaskItem>>([]);

    return Dialog(
      backgroundColor: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const FaIcon(FontAwesomeIcons.circleCheck, color: OnyxColors.success, size: 20),
                const SizedBox(width: 10),
                Text(
                  AppStrings.logDailyAchievement.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                  ),
                ),
                const Spacer(),
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
            Divider(
              height: 20,
              color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
            ),

            // Developer Info
            Text(
              '${AppStrings.developerLabel.tr()}: ${currentUser.name} (${currentUser.stack.label})',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 14),

            // Add Task Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? OnyxColors.neutral800 : OnyxColors.neutral100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tasksWorked.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: taskIdController,
                          decoration: InputDecoration(
                            labelText: AppStrings.taskIdCol.tr(),
                            hintText: 'V5.1.8.GLS.000001',
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: taskTitleController,
                          decoration: InputDecoration(
                            labelText: AppStrings.description.tr(),
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 90,
                        child: TextField(
                          controller: hoursController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: AppStrings.hoursSpent.tr(),
                            suffixText: 'h',
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: OnyxColors.primary,
                          foregroundColor: OnyxColors.lightCard,
                        ),
                        onPressed: () {
                          if (taskTitleController.text.trim().isNotEmpty) {
                            final code = taskIdController.text.trim().isEmpty
                                ? 'V5.1.8.GNR.${(tasksList.value.length + 1).toString().padLeft(6, '0')}'
                                : taskIdController.text.trim();
                            final item = AchievementTaskItem(
                              taskId: 'ach_task_${DateTime.now().millisecondsSinceEpoch}',
                              formattedId: code,
                              title: taskTitleController.text.trim(),
                              moduleCode: moduleController.text.trim(),
                              screenName: screenController.text.trim(),
                              hoursSpent: double.tryParse(hoursController.text) ?? 4.0,
                              status: 'solved',
                            );
                            tasksList.value = [...tasksList.value, item];
                            taskTitleController.clear();
                            taskIdController.clear();
                          }
                        },
                        child: const FaIcon(FontAwesomeIcons.plus, size: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Added Tasks List
            if (tasksList.value.isNotEmpty) ...[
              Text(
                '${AppStrings.tasksWorked.tr()} (${tasksList.value.length}):',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 6),
              ...tasksList.value.map((t) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: OnyxColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: OnyxColors.success.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      TaskIdBadge(formattedId: t.formattedId),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          t.title,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '${t.hoursSpent}h',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: OnyxColors.success,
                        ),
                      ),
                      IconButton(
                        icon: const FaIcon(FontAwesomeIcons.trashCan, size: 14, color: OnyxColors.danger),
                        onPressed: () {
                          tasksList.value = tasksList.value.where((item) => item != t).toList();
                        },
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],

            // Blockers & Next Day Plan
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: blockersController,
                    decoration: InputDecoration(
                      labelText: AppStrings.blockers.tr(),
                      hintText: AppStrings.blockers.tr(),
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: nextDayPlanController,
                    decoration: InputDecoration(
                      labelText: AppStrings.nextDayPlan.tr(),
                      hintText: AppStrings.nextDayPlan.tr(),
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Footer
            Row(
              children: [
                OutlinedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.shareNodes, size: 14),
                  label: Text(AppStrings.copyWhatsappSummary.tr()),
                  onPressed: () {
                    final totalHours = tasksList.value.fold<double>(0.0, (s, t) => s + t.hoursSpent);
                    final achievement = DailyAchievementEntity(
                      id: 'ach_${DateTime.now().millisecondsSinceEpoch}',
                      developerName: currentUser.name,
                      developerStack: currentUser.stack,
                      date: DateTime.now(),
                      tasksWorked: tasksList.value,
                      totalHours: totalHours,
                      blockers: blockersController.text.trim().isNotEmpty ? blockersController.text.trim() : null,
                      nextDayPlan: nextDayPlanController.text.trim().isNotEmpty ? nextDayPlanController.text.trim() : null,
                      submittedAt: DateTime.now(),
                    );
                    Clipboard.setData(ClipboardData(text: achievement.toWhatsAppSummary()));
                    context.safeShowSnackBar(SnackBar(content: Text(AppStrings.whatsappSummaryCopied.tr())));
                  },
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.safePop(),
                  child: Text(AppStrings.cancel.tr()),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OnyxColors.success,
                    foregroundColor: OnyxColors.lightCard,
                  ),
                  onPressed: () async {
                    final totalHours = tasksList.value.fold<double>(0.0, (s, t) => s + t.hoursSpent);
                    final achievement = DailyAchievementEntity(
                      id: '${DateFormat('yyyy_MM_dd').format(DateTime.now())}_${currentUser.id}',
                      developerName: currentUser.name,
                      developerStack: currentUser.stack,
                      date: DateTime.now(),
                      tasksWorked: tasksList.value,
                      totalHours: totalHours,
                      blockers: blockersController.text.trim().isNotEmpty ? blockersController.text.trim() : null,
                      nextDayPlan: nextDayPlanController.text.trim().isNotEmpty ? nextDayPlanController.text.trim() : null,
                      submittedAt: DateTime.now(),
                    );
                    final ok = await achievementCubit.submitDailyAchievement(achievement);
                    if (ok && context.mounted) {
                      context.safeShowSnackBar(SnackBar(content: Text(AppStrings.success.tr())));
                      context.safePop();
                    }
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
