import 'package:fpdart/fpdart.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/core/storage/shared_preferences/app_preferences.dart';
import 'package:onyx_todo/core/storage/shared_preferences/shared_pref_keys.dart';
import 'package:onyx_todo/feature/auth/data/datasources/user_remote_data_source.dart';
import 'package:onyx_todo/feature/auth/domain/entities/user_profile.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';

abstract interface class AuthRepository {
  UserProfile getCurrentUser();
  bool get isAuthenticated;
  Future<void> init();
  List<UserProfile> getAllUsers();
  Future<Either<Failure, List<UserProfile>>> fetchUsers();
  Future<Either<Failure, UserProfile>> switchUser(String userId);
  Future<Either<Failure, UserProfile>> signInWithEmailPassword(String email, String password);
  Future<Either<Failure, UserProfile>> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    DeveloperStack? stack,
  });
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, Unit>> saveUser(UserProfile user);
  Future<Either<Failure, Unit>> resetPassword(String email);
  Future<Either<Failure, int>> autoProvisionUsersFromTasks(List<TaskEntity> tasks);
  Future<Either<Failure, Unit>> updateLastActive(String userId);
}

class AuthRepositoryImpl implements AuthRepository {
  final UserRemoteDataSource userRemoteDataSource;
  final AppPreferences appPreferences;
  UserProfile _currentUser = UserProfile.empty;
  List<UserProfile> _cachedUsers = const [];

  AuthRepositoryImpl({
    required this.userRemoteDataSource,
    required this.appPreferences,
  });

  @override
  bool get isAuthenticated => _currentUser.isNotEmpty;

  @override
  UserProfile getCurrentUser() => _currentUser;

  @override
  Future<void> init() async {
    try {
      final isLoggedIn = await appPreferences.getBool(PrefKeys.isLoggedIn);
      final userId = appPreferences.getString(PrefKeys.userId);
      if (isLoggedIn && userId.isNotEmpty) {
        final user = await userRemoteDataSource.getUserById(userId);
        if (user != null) {
          _currentUser = user;
          return;
        }
      }
      _currentUser = UserProfile.empty;
    } catch (_) {
      _currentUser = UserProfile.empty;
    }
  }

  @override
  List<UserProfile> getAllUsers() => _cachedUsers;

  @override
  Future<Either<Failure, List<UserProfile>>> fetchUsers() async {
    try {
      final users = await userRemoteDataSource.getUsers();
      _cachedUsers = users;
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
        await appPreferences.setData<bool>(key: PrefKeys.isLoggedIn, data: true);
        await appPreferences.setData<String>(key: PrefKeys.userId, data: user.id);
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
      var match = users.where(
        (u) => u.email.trim().toLowerCase() == email.trim().toLowerCase(),
      ).firstOrNull;

      // Automatically seed the primary initial manager account in Firestore if logging in with manager@onyx.com
      if (match == null && email.trim().toLowerCase() == 'manager@onyx.com') {
        final initialManager = UserProfile(
          id: 'usr_manager',
          name: 'Department Manager',
          email: 'manager@onyx.com',
          role: UserRole.departmentManager,
          stack: DeveloperStack.backend,
          isActive: true,
          avatarUrl: 'https://api.dicebear.com/7.x/bottts/png?seed=Manager',
          lastActiveAt: DateTime.now(),
          createdAt: DateTime.now(),
        );
        await userRemoteDataSource.saveUser(initialManager);
        match = initialManager;
      }

      if (match == null) {
        return const Left(ServerFailure(code: 404, message: 'User not found'));
      }

      _currentUser = match;
      await appPreferences.setData<bool>(key: PrefKeys.isLoggedIn, data: true);
      await appPreferences.setData<String>(key: PrefKeys.userId, data: match.id);
      await userRemoteDataSource.updateLastActive(_currentUser.id);
      return Right(_currentUser);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    DeveloperStack? stack,
  }) async {
    try {
      final existingUsers = await userRemoteDataSource.getUsers();
      final duplicate = existingUsers.where(
        (u) => u.email.trim().toLowerCase() == email.trim().toLowerCase(),
      ).firstOrNull;
      if (duplicate != null) {
        return const Left(ServerFailure(code: 409, message: 'Email already registered'));
      }

      final newUser = UserProfile(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: name.trim(),
        email: email.trim().toLowerCase(),
        role: role,
        stack: stack ?? DeveloperStack.frontend,
        isActive: true,
        avatarUrl: 'https://api.dicebear.com/7.x/bottts/png?seed=${Uri.encodeComponent(name.trim())}',
        lastActiveAt: DateTime.now(),
        createdAt: DateTime.now(),
      );

      await userRemoteDataSource.saveUser(newUser);
      _currentUser = newUser;
      await appPreferences.setData<bool>(key: PrefKeys.isLoggedIn, data: true);
      await appPreferences.setData<String>(key: PrefKeys.userId, data: newUser.id);
      return Right(newUser);
    } catch (e) {
      return Left(ServerFailure(code: -1, message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    _currentUser = UserProfile.empty;
    await appPreferences.setData<bool>(key: PrefKeys.isLoggedIn, data: false);
    await appPreferences.setData<String>(key: PrefKeys.userId, data: '');
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
