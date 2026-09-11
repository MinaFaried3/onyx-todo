import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_history_item.dart';
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
        color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
        border: Border(
          left: BorderSide(
            color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
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
                  color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
                ),
              ),
            ),
            child: Row(
              children: [
                TaskIdBadge(formattedId: task.formattedId, isLarge: true),
                const SizedBox(width: 8),
                Text(
                  task.moduleCode,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
                  icon: const Icon(Icons.close_rounded, size: 20),
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
                    const Icon(Icons.layers_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      '${AppStrings.screenName.tr()}: ',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: ClickUpColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        task.screenName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ClickUpColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Editable Title
                TextField(
                  controller: titleController,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
                        color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
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
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildAssigneeRow(
                  AppStrings.frontendDev.tr(),
                  task.frontendDevName ?? 'غير محدد',
                  Icons.laptop_chromebook_rounded,
                  Colors.teal,
                ),
                _buildAssigneeRow(
                  AppStrings.backendDev.tr(),
                  task.backendDevName ?? 'غير محدد',
                  Icons.dns_rounded,
                  Colors.deepPurple,
                ),
                if (task.qaTesterName != null)
                  _buildAssigneeRow(
                    AppStrings.qaTester.tr(),
                    task.qaTesterName!,
                    Icons.verified_outlined,
                    Colors.amber,
                  ),
                const SizedBox(height: 20),

                // Dev & QA Notes
                if (task.devNotes != null && task.devNotes!.isNotEmpty) ...[
                  Text(
                    AppStrings.devNotes.tr(),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(task.devNotes!, style: const TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(height: 16),
                ],

                // Activity & History Trail
                Text(
                  AppStrings.activityHistory.tr(),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (task.history.isEmpty)
                  const Text(
                    'لا يوجد سجل تغييرات بعد',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  )
                else
                  ...task.history.reversed.map((h) => _buildHistoryTile(h)),

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
                        backgroundColor: ClickUpColors.primary,
                        foregroundColor: Colors.white,
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
                      child: const Icon(Icons.send_rounded, size: 16),
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

  Widget _buildAssigneeRow(String label, String name, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildHistoryTile(TaskHistoryItem item) {
    final timeStr = DateFormat('yyyy/MM/dd HH:mm').format(item.timestamp);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: ClickUpColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.authorName,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(timeStr, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                Text(item.details, style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
