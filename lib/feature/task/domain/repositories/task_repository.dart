import 'package:fpdart/fpdart.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';

abstract interface class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks({
    String? moduleCode,
    String? version,
    String? status,
    String? assigneeName,
    int page = 1,
    int limit = 25,
  });

  Future<Either<Failure, TaskEntity>> createTask({
    required String version,
    required String moduleCode,
    required String screenName,
    required String title,
    String description = '',
    String taskType = 'task',
    String priority = 'medium',
    String? backendDevName,
    String? frontendDevName,
    String? middleDevName,
    String? qaTesterName,
    double estimatedHours = 0.0,
    String? devNotes,
  });

  Future<Either<Failure, Unit>> updateTaskStatus({
    required String taskId,
    required String newStatus,
    required String authorName,
    String? note,
  });

  Future<Either<Failure, Unit>> updateTask(TaskEntity task);

  Future<Either<Failure, int>> importTasks(
    List<TaskEntity> tasks, {
    void Function(int uploaded, int total)? onProgress,
  });
}
