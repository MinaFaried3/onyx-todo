import 'package:fpdart/fpdart.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/month_plan/data/datasources/month_plan_remote_data_source.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_entity.dart';

abstract interface class MonthPlanRepository {
  Future<Either<Failure, List<MonthlyPlanEntity>>> getPlans({
    int? month,
    int? year,
    String? developerName,
  });

  Future<Either<Failure, MonthlyPlanEntity?>> getPlanById(String planId);

  Future<Either<Failure, Unit>> savePlan(MonthlyPlanEntity plan);

  Future<Either<Failure, Unit>> updatePlanStatus({
    required String planId,
    required String status,
    String? managerNotes,
  });
}

class MonthPlanRepositoryImpl implements MonthPlanRepository {
  final MonthPlanRemoteDataSource remoteDataSource;

  MonthPlanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MonthlyPlanEntity>>> getPlans({
    int? month,
    int? year,
    String? developerName,
  }) async {
    try {
      final plans = await remoteDataSource.getPlans(
        month: month,
        year: year,
        developerName: developerName,
      );
      return Right(plans);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MonthlyPlanEntity?>> getPlanById(String planId) async {
    try {
      final plan = await remoteDataSource.getPlanById(planId);
      return Right(plan);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> savePlan(MonthlyPlanEntity plan) async {
    try {
      await remoteDataSource.savePlan(plan);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePlanStatus({
    required String planId,
    required String status,
    String? managerNotes,
  }) async {
    try {
      await remoteDataSource.updatePlanStatus(
        planId: planId,
        status: status,
        managerNotes: managerNotes,
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }
}
