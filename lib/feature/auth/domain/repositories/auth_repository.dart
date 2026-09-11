import 'package:fpdart/fpdart.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';
import 'package:onyx_todo/feature/auth/domain/entities/user_profile.dart';

abstract interface class AuthRepository {
  UserProfile getCurrentUser();
  List<UserProfile> getAllUsers();
  Future<Either<Failure, UserProfile>> switchUser(String userId);
  Future<Either<Failure, UserProfile>> signInWithEmailPassword(String email, String password);
  Future<Either<Failure, Unit>> signOut();
}

class AuthRepositoryImpl implements AuthRepository {
  UserProfile _currentUser = UserProfile.demoUsers.first; // Defaults to Department Manager

  @override
  UserProfile getCurrentUser() => _currentUser;

  @override
  List<UserProfile> getAllUsers() => UserProfile.demoUsers;

  @override
  Future<Either<Failure, UserProfile>> switchUser(String userId) async {
    final user = UserProfile.demoUsers.firstWhere(
      (u) => u.id == userId,
      orElse: () => _currentUser,
    );
    _currentUser = user;
    return Right(_currentUser);
  }

  @override
  Future<Either<Failure, UserProfile>> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    final match = UserProfile.demoUsers.firstWhere(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
      orElse: () => UserProfile(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@').first,
        email: email,
      ),
    );
    _currentUser = match;
    return Right(_currentUser);
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    _currentUser = UserProfile.demoUsers.first;
    return const Right(unit);
  }
}
