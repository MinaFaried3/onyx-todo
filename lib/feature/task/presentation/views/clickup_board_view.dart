import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_card.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_create_dialog.dart';

class ClickUpBoardView extends StatelessWidget {
  final List<TaskEntity> tasks;

  const ClickUpBoardView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final tasksCubit = context.tasksCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Group tasks by status
    final Map<TaskStatus, List<TaskEntity>> grouped = {};
    for (final status in TaskStatus.values) {
      grouped[status] = [];
    }
    for (final task in tasks) {
      grouped[task.status]?.add(task);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: TaskStatus.values.map((status) {
          final columnTasks = grouped[status] ?? [];
          return _BoardColumn(
            status: status,
            tasks: columnTasks,
            isDark: isDark,
            onTaskTap: (t) => tasksCubit.selectTask(t),
            onTaskStatusChanged: (task) {
              tasksCubit.updateTaskStatus(
                taskId: task.id,
                newStatus: task.status,
                authorName: 'User',
              );
            },
            onDropTask: (droppedTask) {
              if (droppedTask.status != status) {
                tasksCubit.updateTaskStatus(
                  taskId: droppedTask.id,
                  newStatus: status,
                  authorName: 'User',
                );
              }
            },
            onAddTask: () {
              showDialog(
                context: context,
                builder: (ctx) => const TaskCreateDialog(),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class _BoardColumn extends StatelessWidget {
  final TaskStatus status;
  final List<TaskEntity> tasks;
  final bool isDark;
  final ValueChanged<TaskEntity> onTaskTap;
  final ValueChanged<TaskEntity> onTaskStatusChanged;
  final ValueChanged<TaskEntity> onDropTask;
  final VoidCallback onAddTask;

  const _BoardColumn({
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
        color: isDark ? ClickUpColors.darkSidebar : ClickUpColors.lightSidebar,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
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
                          color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
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
                        icon: const Icon(Icons.add_rounded, size: 18),
                        tooltip: AppStrings.createTask.tr(),
                        onPressed: onAddTask,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

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
