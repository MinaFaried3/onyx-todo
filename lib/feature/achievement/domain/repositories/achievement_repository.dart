import 'package:fpdart/fpdart.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/achievement/data/datasources/achievement_remote_data_source.dart';
import 'package:onyx_todo/feature/achievement/domain/entities/daily_achievement_entity.dart';

abstract interface class AchievementRepository {
  Future<Either<Failure, List<DailyAchievementEntity>>> getAchievements({
    DateTime? startDate,
    DateTime? endDate,
    String? developerName,
  });

  Future<Either<Failure, Unit>> submitAchievement(DailyAchievementEntity achievement);
}

class AchievementRepositoryImpl implements AchievementRepository {
  final AchievementRemoteDataSource remoteDataSource;

  AchievementRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<DailyAchievementEntity>>> getAchievements({
    DateTime? startDate,
    DateTime? endDate,
    String? developerName,
  }) async {
    try {
      final list = await remoteDataSource.getAchievements(
        startDate: startDate,
        endDate: endDate,
        developerName: developerName,
      );
      return Right(list);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitAchievement(DailyAchievementEntity achievement) async {
    try {
      await remoteDataSource.submitAchievement(achievement);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }
}
