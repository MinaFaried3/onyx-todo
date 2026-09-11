import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_history_item.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/assignee_info_row.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_history_tile.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_priority_flag.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_status_pill.dart';

class TaskDrawerDetail extends HookWidget {
  final TaskEntity task;
  final VoidCallback onClose;

  const TaskDrawerDetail({
    super.key,
    required this.task,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final tasksCubit = context.tasksCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleController = useTextEditingController(text: task.title);
    final descController = useTextEditingController(text: task.description);
    final commentController = useTextEditingController();
    final actualHoursController =
        useTextEditingController(text: task.actualHours > 0 ? task.actualHours.toString() : '');
    final estimatedHoursController =
        useTextEditingController(text: task.estimatedHours > 0 ? task.estimatedHours.toString() : '');

    return Container(
      width: 520,
      decoration: BoxDecoration(
        color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
        border: Border(
          left: BorderSide(
            color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Top Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                ),
              ),
            ),
            child: Row(
              children: [
                TaskIdBadge(formattedId: task.formattedId, isLarge: true),
                const SizedBox(width: 8),
                Text(
                  task.moduleCode,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                  ),
                ),
                const Spacer(),
                TaskPriorityFlag(
                  priority: task.priority,
                  onPriorityChanged: (p) {
                    tasksCubit.updateTask(task.copyWith(priority: p));
                  },
                ),
                const SizedBox(width: 8),
                TaskStatusPill(
                  status: task.status,
                  onStatusChanged: (s) {
                    tasksCubit.updateTaskStatus(
                      taskId: task.id,
                      newStatus: s,
                      authorName: 'User',
                    );
                  },
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.xmark,
                    size: 16,
                    color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
                  ),
                  tooltip: AppStrings.close.tr(),
                  onPressed: onClose,
                ),
              ],
            ),
          ),

          // Scrollable Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Screen Name Badge
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.layerGroup,
                      size: 14,
                      color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${AppStrings.screenName.tr()}: ',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: OnyxColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        task.screenName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: OnyxColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Editable Title
                TextField(
                  controller: titleController,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppStrings.taskTitle.tr(),
                  ),
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      tasksCubit.updateTask(task.copyWith(title: val.trim()));
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Description Field
                Text(
                  AppStrings.description.tr(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                  decoration: InputDecoration(
                    hintText: AppStrings.description.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                      ),
                    ),
                  ),
                  onSubmitted: (val) {
                    tasksCubit.updateTask(task.copyWith(description: val));
                  },
                ),
                const SizedBox(height: 20),

                // Hours Tracking (Estimated vs Actual)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.estimatedHours.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: estimatedHoursController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffixText: 'h',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              isDense: true,
                            ),
                            onSubmitted: (val) {
                              final h = double.tryParse(val) ?? 0.0;
                              tasksCubit.updateTask(task.copyWith(estimatedHours: h));
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.actualHours.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: actualHoursController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffixText: 'h',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              isDense: true,
                            ),
                            onSubmitted: (val) {
                              final h = double.tryParse(val) ?? 0.0;
                              tasksCubit.updateTask(task.copyWith(actualHours: h));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Assignees Information
                Text(
                  AppStrings.assignees.tr(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                AssigneeInfoRow(
                  label: AppStrings.frontendDev.tr(),
                  name: task.frontendDevName ?? AppStrings.unassigned.tr(),
                  icon: FontAwesomeIcons.laptopCode,
                  color: OnyxColors.teal,
                ),
                AssigneeInfoRow(
                  label: AppStrings.backendDev.tr(),
                  name: task.backendDevName ?? AppStrings.unassigned.tr(),
                  icon: FontAwesomeIcons.server,
                  color: OnyxColors.purple,
                ),
                if (task.qaTesterName != null)
                  AssigneeInfoRow(
                    label: AppStrings.qaTester.tr(),
                    name: task.qaTesterName!,
                    icon: FontAwesomeIcons.circleCheck,
                    color: OnyxColors.warning,
                  ),
                const SizedBox(height: 20),

                // Dev & QA Notes
                if (task.devNotes != null && task.devNotes!.isNotEmpty) ...[
                  Text(
                    AppStrings.devNotes.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: OnyxColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: OnyxColors.info.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      task.devNotes!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Activity & History Trail
                Text(
                  AppStrings.activityHistory.tr(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                if (task.history.isEmpty)
                  Text(
                    AppStrings.noHistoryYet.tr(),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                    ),
                  )
                else
                  ...task.history.reversed.map((h) => TaskHistoryTile(item: h)),

                const SizedBox(height: 20),

                // Add Comment
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: AppStrings.addComment.tr(),
                          isDense: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                        if (commentController.text.trim().isNotEmpty) {
                          final item = TaskHistoryItem(
                            id: 'c_${DateTime.now().millisecondsSinceEpoch}',
                            action: 'comment',
                            authorName: 'User',
                            timestamp: DateTime.now(),
                            details: commentController.text.trim(),
                          );
                          tasksCubit.updateTask(
                            task.copyWith(history: [...task.history, item]),
                          );
                          commentController.clear();
                        }
                      },
                      child: const FaIcon(FontAwesomeIcons.paperPlane, size: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
