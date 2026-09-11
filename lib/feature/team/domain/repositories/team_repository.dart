import 'package:fpdart/fpdart.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/team/data/datasources/team_remote_data_source.dart';
import 'package:onyx_todo/feature/team/domain/entities/team_entity.dart';

abstract interface class TeamRepository {
  Future<Either<Failure, List<TeamEntity>>> getTeams();
  Future<Either<Failure, TeamEntity>> getTeamById(String id);
  Future<Either<Failure, Unit>> createTeam(TeamEntity team);
  Future<Either<Failure, Unit>> updateTeam(TeamEntity team);
  Future<Either<Failure, Unit>> deleteTeam(String id);
  Future<Either<Failure, Unit>> assignMember(String teamId, String userId);
}

class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource remoteDataSource;

  TeamRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TeamEntity>>> getTeams() async {
    try {
      final teams = await remoteDataSource.getTeams();
      return Right(teams);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TeamEntity>> getTeamById(String id) async {
    try {
      final team = await remoteDataSource.getTeamById(id);
      if (team != null) {
        return Right(team);
      }
      return const Left(ServerFailure(code: -1, message: 'Team not found'));
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createTeam(TeamEntity team) async {
    try {
      await remoteDataSource.createTeam(team);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTeam(TeamEntity team) async {
    try {
      await remoteDataSource.updateTeam(team);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTeam(String id) async {
    try {
      await remoteDataSource.deleteTeam(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> assignMember(String teamId, String userId) async {
    try {
      await remoteDataSource.assignMember(teamId, userId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }
}
