import 'package:flutter/material.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/board_column.dart';
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
          return BoardColumn(
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
