import 'package:fpdart/fpdart.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/notification/data/datasources/notification_remote_data_source.dart';
import 'package:onyx_todo/feature/notification/domain/entities/system_notification_entity.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, List<SystemNotificationEntity>>> getNotifications(String userId);
  Future<Either<Failure, Unit>> sendNotification(SystemNotificationEntity notification);
  Future<Either<Failure, Unit>> markAsRead(String notificationId);
  Future<Either<Failure, Unit>> markAllAsRead(String userId);
}

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SystemNotificationEntity>>> getNotifications(String userId) async {
    try {
      final notifs = await remoteDataSource.getNotifications(userId);
      return Right(notifs);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendNotification(SystemNotificationEntity notification) async {
    try {
      await remoteDataSource.sendNotification(notification);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead(String userId) async {
    try {
      await remoteDataSource.markAllAsRead(userId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }
}
