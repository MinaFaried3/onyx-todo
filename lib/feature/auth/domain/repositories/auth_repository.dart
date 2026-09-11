import 'package:fpdart/fpdart.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/auth/data/datasources/user_remote_data_source.dart';
import 'package:onyx_todo/feature/auth/domain/entities/user_profile.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';

abstract interface class AuthRepository {
  UserProfile getCurrentUser();
  List<UserProfile> getAllUsers();
  Future<Either<Failure, List<UserProfile>>> fetchUsers();
  Future<Either<Failure, UserProfile>> switchUser(String userId);
  Future<Either<Failure, UserProfile>> signInWithEmailPassword(String email, String password);
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, Unit>> saveUser(UserProfile user);
  Future<Either<Failure, Unit>> resetPassword(String email);
  Future<Either<Failure, int>> autoProvisionUsersFromTasks(List<TaskEntity> tasks);
  Future<Either<Failure, Unit>> updateLastActive(String userId);
}

class AuthRepositoryImpl implements AuthRepository {
  final UserRemoteDataSource userRemoteDataSource;
  UserProfile _currentUser;

  AuthRepositoryImpl({required this.userRemoteDataSource})
      : _currentUser = UserProfile.demoUsers.first; // Default Manager credibility

  @override
  UserProfile getCurrentUser() => _currentUser;

  @override
  List<UserProfile> getAllUsers() => UserProfile.demoUsers;

  @override
  Future<Either<Failure, List<UserProfile>>> fetchUsers() async {
    try {
      final users = await userRemoteDataSource.getUsers();
      // Keep currentUser synced if it exists in returned list
      final currentMatch = users.where((u) => u.id == _currentUser.id).firstOrNull;
      if (currentMatch != null) {
        _currentUser = currentMatch;
      }
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> switchUser(String userId) async {
    try {
      final user = await userRemoteDataSource.getUserById(userId);
      if (user != null) {
        _currentUser = user;
        await userRemoteDataSource.updateLastActive(userId);
        return Right(_currentUser);
      }
      return const Left(ServerFailure(code: -1, message: 'User not found'));
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final users = await userRemoteDataSource.getUsers();
      final match = users.firstWhere(
        (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
        orElse: () => UserProfile(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          name: email.split('@').first,
          email: email,
        ),
      );
      _currentUser = match;
      await userRemoteDataSource.updateLastActive(_currentUser.id);
      return Right(_currentUser);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    _currentUser = UserProfile.demoUsers.first; // Defaults back to Manager
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> saveUser(UserProfile user) async {
    try {
      await userRemoteDataSource.saveUser(user);
      if (user.id == _currentUser.id) {
        _currentUser = user;
      }
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(String email) async {
    try {
      await userRemoteDataSource.resetPassword(email);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> autoProvisionUsersFromTasks(List<TaskEntity> tasks) async {
    try {
      final count = await userRemoteDataSource.autoProvisionUsersFromTasks(tasks);
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateLastActive(String userId) async {
    try {
      await userRemoteDataSource.updateLastActive(userId);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }
}
