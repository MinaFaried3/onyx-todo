import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';

class TaskSubtasksSection extends HookWidget {
  final TaskEntity task;
  final bool isDark;
  final String authorName;

  const TaskSubtasksSection({
    super.key,
    required this.task,
    required this.isDark,
    required this.authorName,
  });

  @override
  Widget build(BuildContext context) {
    final tasksCubit = context.tasksCubit;
    final isAdding = useState<bool>(false);
    final textController = useTextEditingController();
    final focusNode = useFocusNode();

    Future<void> submitNewSubtask() async {
      final title = textController.text.trim();
      if (title.isEmpty) return;

      await tasksCubit.addSubtask(
        taskId: task.id,
        title: title,
        authorName: authorName,
      );

      textController.clear();
      isAdding.value = false;
    }

    final total = task.totalSubtasks;
    final completed = task.completedSubtasks;
    final progress = task.subtaskProgress;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? OnyxColors.darkSurface : OnyxColors.neutral50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Header ────────────────────────────────────────────────────────
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.diagramProject,
                size: 13,
                color: OnyxColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.subtasks.tr(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: OnyxColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$completed / $total',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: OnyxColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  isAdding.value = !isAdding.value;
                  if (isAdding.value) {
                    Future.microtask(() => focusNode.requestFocus());
                  }
                },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        isAdding.value ? FontAwesomeIcons.xmark : FontAwesomeIcons.plus,
                        size: 11,
                        color: OnyxColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isAdding.value ? AppStrings.close.tr() : AppStrings.addSubtask.tr(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: OnyxColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ─── Progress Bar (if subtasks exist) ──────────────────────────────
          if (total > 0) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: isDark ? OnyxColors.neutral800 : OnyxColors.neutral200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress == 1.0 ? OnyxColors.success : OnyxColors.primary,
                ),
              ),
            ),
          ],

          const SizedBox(height: 10),

          // ─── Subtasks List ──────────────────────────────────────────────────
          if (task.subtasks.isEmpty && !isAdding.value)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                AppStrings.noSubtasks.tr(),
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: isDark ? OnyxColors.neutral500 : OnyxColors.neutral400,
                ),
              ),
            )
          else
            ...task.subtasks.map((subtask) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? OnyxColors.darkCard : OnyxColors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    // Checkbox
                    Checkbox(
                      value: subtask.isCompleted,
                      activeColor: OnyxColors.success,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      onChanged: (_) {
                        tasksCubit.toggleSubtask(
                          taskId: task.id,
                          subtaskId: subtask.id,
                          authorName: authorName,
                        );
                      },
                    ),
                    const SizedBox(width: 6),

                    // Title
                    Expanded(
                      child: Text(
                        subtask.title,
                        style: TextStyle(
                          fontSize: 12,
                          decoration: subtask.isCompleted ? TextDecoration.lineThrough : null,
                          color: subtask.isCompleted
                              ? (isDark ? OnyxColors.neutral500 : OnyxColors.neutral400)
                              : (isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary),
                          fontWeight: subtask.isCompleted ? FontWeight.normal : FontWeight.w500,
                        ),
                      ),
                    ),

                    // Delete Subtask button
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.trashCan,
                        size: 11,
                        color: OnyxColors.danger,
                      ),
                      tooltip: AppStrings.delete.tr(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        tasksCubit.deleteSubtask(
                          taskId: task.id,
                          subtaskId: subtask.id,
                          authorName: authorName,
                        );
                      },
                    ),
                  ],
                ),
              );
            }),

          // ─── Inline Add Subtask Input ───────────────────────────────────────
          if (isAdding.value) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: TextField(
                      controller: textController,
                      focusNode: focusNode,
                      style: const TextStyle(fontSize: 12),
                      onSubmitted: (_) => submitNewSubtask(),
                      decoration: InputDecoration(
                        hintText: AppStrings.subtaskTitle.tr(),
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: isDark ? OnyxColors.neutral500 : OnyxColors.neutral400,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        filled: true,
                        fillColor: isDark ? OnyxColors.darkCard : OnyxColors.white,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: OnyxColors.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: OnyxColors.primary, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OnyxColors.primary,
                    foregroundColor: OnyxColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    minimumSize: const Size(0, 36),
                  ),
                  onPressed: submitNewSubtask,
                  child: Text(
                    AppStrings.add.tr(),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
