import 'package:fpdart/fpdart.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/task/data/datasources/task_remote_data_source.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_history_item.dart';
import 'package:onyx_todo/feature/task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;

  TaskRepositoryImpl({required TaskRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks({
    String? moduleCode,
    String? version,
    String? status,
    String? assigneeName,
  }) async {
    try {
      final tasks = await _remoteDataSource.getTasks(
        moduleCode: moduleCode,
        version: version,
        status: status,
        assigneeName: assigneeName,
      );
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final seq = await _remoteDataSource.getNextSequenceNumber(
        version: version,
        moduleCode: moduleCode,
      );

      final formattedId = TaskEntity.generateFormattedId(
        version: version,
        moduleCode: moduleCode,
        sequenceNumber: seq,
      );

      final initialHistory = TaskHistoryItem(
        id: 'h_${DateTime.now().millisecondsSinceEpoch}',
        action: 'created',
        authorName: frontendDevName ?? backendDevName ?? 'System',
        timestamp: DateTime.now(),
        details: 'Task created with ID $formattedId',
      );

      final newTask = TaskEntity(
        id: formattedId,
        formattedId: formattedId,
        version: version,
        moduleCode: moduleCode.toUpperCase(),
        sequenceNumber: seq,
        screenName: screenName,
        title: title,
        description: description,
        taskType: TaskType.fromString(taskType),
        priority: TaskPriority.fromString(priority),
        status: TaskStatus.open,
        backendDevName: backendDevName,
        frontendDevName: frontendDevName,
        middleDevName: middleDevName,
        qaTesterName: qaTesterName,
        createdDate: DateTime.now(),
        estimatedHours: estimatedHours,
        devNotes: devNotes,
        history: [initialHistory],
      );

      final created = await _remoteDataSource.createTask(newTask);
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTaskStatus({
    required String taskId,
    required String newStatus,
    required String authorName,
    String? note,
  }) async {
    try {
      await _remoteDataSource.updateTaskStatus(
        taskId: taskId,
        newStatus: newStatus,
        authorName: authorName,
        note: note,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTask(TaskEntity task) async {
    try {
      await _remoteDataSource.updateTask(task);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> importTasks(List<TaskEntity> tasks) async {
    try {
      final count = await _remoteDataSource.batchImportTasks(tasks);
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }
}
