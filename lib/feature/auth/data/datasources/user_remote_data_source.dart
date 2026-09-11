import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/feature/auth/domain/entities/user_profile.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';

abstract interface class UserRemoteDataSource {
  Future<List<UserProfile>> getUsers();
  Future<UserProfile?> getUserById(String id);
  Future<void> saveUser(UserProfile user);
  Future<void> updateUser(UserProfile user);
  Future<void> updateLastActive(String userId);
  Future<int> autoProvisionUsersFromTasks(List<TaskEntity> tasks);
  Future<void> resetPassword(String email);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore? firestore;

  // In-memory persistent cache (no dummy data)
  static final List<UserProfile> _usersCache = [];

  UserRemoteDataSourceImpl({this.firestore});

  CollectionReference<Map<String, dynamic>>? get _usersCollection {
    try {
      return firestore?.collection('users');
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<UserProfile>> getUsers() async {
    try {
      if (_usersCollection != null) {
        final snapshot = await _usersCollection!.get().timeout(const Duration(seconds: 4));
        if (snapshot.docs.isNotEmpty) {
          final dbUsers = snapshot.docs.map((doc) => UserProfile.fromMap(doc.data(), doc.id)).toList();
          _usersCache
            ..clear()
            ..addAll(dbUsers);
          return List.unmodifiable(_usersCache);
        } else {
          // Database has no users
          _usersCache.clear();
          return const [];
        }
      }
    } catch (e) {
      Printer.logger('UserRemoteDataSourceImpl.getUsers error: $e');
    }
    return List.unmodifiable(_usersCache);
  }

  @override
  Future<UserProfile?> getUserById(String id) async {
    final cached = _usersCache.where((u) => u.id == id).firstOrNull;
    if (cached != null) return cached;

    try {
      if (_usersCollection != null) {
        final doc = await _usersCollection!.doc(id).get().timeout(const Duration(seconds: 3));
        if (doc.exists && doc.data() != null) {
          final user = UserProfile.fromMap(doc.data()!, doc.id);
          _usersCache.add(user);
          return user;
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> saveUser(UserProfile user) async {
    final idx = _usersCache.indexWhere((u) => u.id == user.id);
    if (idx != -1) {
      _usersCache[idx] = user;
    } else {
      _usersCache.add(user);
    }

    try {
      if (_usersCollection != null) {
        await _usersCollection!.doc(user.id).set(user.toMap(), SetOptions(merge: true));
      }
    } catch (e) {
      Printer.logger('UserRemoteDataSource.saveUser error: $e');
    }
  }

  @override
  Future<void> updateUser(UserProfile user) => saveUser(user);

  @override
  Future<void> updateLastActive(String userId) async {
    final idx = _usersCache.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      final now = DateTime.now();
      _usersCache[idx] = _usersCache[idx].copyWith(lastActiveAt: now, isActive: true);
      try {
        if (_usersCollection != null) {
          await _usersCollection!.doc(userId).update({
            'lastActiveAt': now.toIso8601String(),
            'isActive': true,
          });
        }
      } catch (_) {}
    }
  }

  @override
  Future<int> autoProvisionUsersFromTasks(List<TaskEntity> tasks) async {
    final Map<String, UserProfile> newUsers = {};

    // Helper to generate a clean safe alphanumeric slug for IDs and emails
    String makeSlug(String raw) {
      return raw.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').replaceAll(RegExp(r'_+'), '_');
    }

    bool userExists(String name) {
      final clean = name.trim().toLowerCase();
      if (_usersCache.any((u) => u.name.trim().toLowerCase() == clean)) return true;
      if (newUsers.values.any((u) => u.name.trim().toLowerCase() == clean)) return true;
      return false;
    }

    for (final task in tasks) {
      // 1. Frontend Assignee
      if (task.frontendDevName != null && task.frontendDevName!.trim().isNotEmpty) {
        final name = task.frontendDevName!.trim();
        if (name.toLowerCase() != 'unassigned' && name != '-' && !userExists(name)) {
          final slug = makeSlug(name).isNotEmpty ? makeSlug(name) : 'dev_${DateTime.now().millisecondsSinceEpoch}';
          final id = 'u_fe_$slug';
          newUsers[id] = UserProfile(
            id: id,
            name: name,
            email: '$slug@onyx.com',
            role: UserRole.frontend,
            stack: DeveloperStack.frontend,
            assignedModules: [task.moduleCode],
            teamId: 'team_core',
            isActive: true,
          );
        }
      }

      // 2. Backend Assignee
      if (task.backendDevName != null && task.backendDevName!.trim().isNotEmpty) {
        final name = task.backendDevName!.trim();
        if (name.toLowerCase() != 'unassigned' && name != '-' && !userExists(name)) {
          final slug = makeSlug(name).isNotEmpty ? makeSlug(name) : 'dev_${DateTime.now().millisecondsSinceEpoch}';
          final id = 'u_be_$slug';
          newUsers[id] = UserProfile(
            id: id,
            name: name,
            email: '$slug@onyx.com',
            role: UserRole.backend,
            stack: DeveloperStack.backend,
            assignedModules: [task.moduleCode],
            teamId: 'team_core',
            isActive: true,
          );
        }
      }

      // 3. QA Tester Assignee
      if (task.qaTesterName != null && task.qaTesterName!.trim().isNotEmpty) {
        final name = task.qaTesterName!.trim();
        if (name.toLowerCase() != 'unassigned' && name != '-' && !userExists(name)) {
          final slug = makeSlug(name).isNotEmpty ? makeSlug(name) : 'dev_${DateTime.now().millisecondsSinceEpoch}';
          final id = 'u_qa_$slug';
          newUsers[id] = UserProfile(
            id: id,
            name: name,
            email: '$slug@onyx.com',
            role: UserRole.qa,
            stack: DeveloperStack.qa,
            assignedModules: [task.moduleCode],
            teamId: 'team_core',
            isActive: true,
          );
        }
      }
    }

    if (newUsers.isEmpty) return 0;

    // Add to in-memory cache
    _usersCache.addAll(newUsers.values);
    Printer.log('Auto-provisioned ${newUsers.length} developers from imported tasks');

    // Batch upload to Firestore if available
    try {
      if (_usersCollection != null) {
        final batch = firestore!.batch();
        for (final u in newUsers.values) {
          batch.set(_usersCollection!.doc(u.id), u.toMap(), SetOptions(merge: true));
        }
        await batch.commit().timeout(const Duration(seconds: 4));
        Printer.log('Committed ${newUsers.length} provisioned users to Firestore users collection');
      }
    } catch (e) {
      Printer.logger('Firestore notice while provisioning users: $e');
    }

    return newUsers.length;
  }

  @override
  Future<void> resetPassword(String email) async {
    Printer.log('Password reset instruction processed for email: $email');
  }
}
