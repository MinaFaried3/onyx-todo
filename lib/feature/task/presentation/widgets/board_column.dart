import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_card.dart';

class BoardColumn extends StatelessWidget {
  final TaskStatus status;
  final List<TaskEntity> tasks;
  final bool isDark;
  final ValueChanged<TaskEntity> onTaskTap;
  final ValueChanged<TaskEntity> onTaskStatusChanged;
  final ValueChanged<TaskEntity> onDropTask;
  final VoidCallback onAddTask;

  const BoardColumn({
    super.key,
    required this.status,
    required this.tasks,
    required this.isDark,
    required this.onTaskTap,
    required this.onTaskStatusChanged,
    required this.onDropTask,
    required this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isDark ? OnyxColors.darkSidebar : OnyxColors.lightSidebar,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
        ),
      ),
      child: DragTarget<TaskEntity>(
        onWillAcceptWithDetails: (_) => true,
        onAcceptWithDetails: (details) => onDropTask(details.data),
        builder: (context, candidateData, rejectedData) {
          final isTargetHovered = candidateData.isNotEmpty;
          return Container(
            decoration: BoxDecoration(
              color: isTargetHovered
                  ? status.color.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                // Column Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: status.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: status.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${tasks.length}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: status.color,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.plus,
                          size: 13,
                          color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
                        ),
                        tooltip: AppStrings.createTask.tr(),
                        onPressed: onAddTask,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                ),

                // Cards List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Draggable<TaskEntity>(
                        data: task,
                        feedback: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 270,
                            child: TaskCard(task: task, onTap: () {}),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: TaskCard(task: task, onTap: () {}),
                        ),
                        child: TaskCard(
                          task: task,
                          onTap: () => onTaskTap(task),
                          onStatusChanged: onTaskStatusChanged,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
