import 'package:equatable/equatable.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';

typedef UserEntity = UserProfile;

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final DeveloperStack stack;
  final String? teamId;
  final List<String> assignedModules;
  final String? avatarUrl;
  final bool isActive;
  final DateTime lastActiveAt;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.developer,
    this.stack = DeveloperStack.frontend,
    this.teamId,
    this.assignedModules = const [],
    this.avatarUrl,
    this.isActive = true,
    DateTime? lastActiveAt,
    DateTime? createdAt,
  })  : lastActiveAt = lastActiveAt ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  bool get isDepartmentManager => role == UserRole.departmentManager;
  bool get isTeamLead => role == UserRole.teamLead || role == UserRole.frontendLead;
  bool get isLeader => isDepartmentManager || isTeamLead;
  bool get canManageTeam => isDepartmentManager;

  static final UserProfile empty = UserProfile(
    id: '',
    name: '',
    email: '',
    role: UserRole.developer,
    stack: DeveloperStack.frontend,
  );

  bool get isEmpty => id.isEmpty;
  bool get isNotEmpty => id.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        role,
        stack,
        teamId,
        assignedModules,
        avatarUrl,
        isActive,
        lastActiveAt,
        createdAt,
      ];

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    DeveloperStack? stack,
    String? teamId,
    List<String>? assignedModules,
    String? avatarUrl,
    bool? isActive,
    DateTime? lastActiveAt,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      stack: stack ?? this.stack,
      teamId: teamId ?? this.teamId,
      assignedModules: assignedModules ?? this.assignedModules,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.value,
      'stack': stack.value,
      'teamId': teamId,
      'assignedModules': assignedModules,
      'avatarUrl': avatarUrl,
      'isActive': isActive,
      'lastActiveAt': lastActiveAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, [String? docId]) {
    final roleStr = map['role'] as String? ?? 'developer';
    final role = UserRole.values.firstWhere(
      (r) => r.value == roleStr,
      orElse: () => UserRole.developer,
    );

    final stackStr = map['stack'] as String? ?? 'frontend';
    final stack = DeveloperStack.values.firstWhere(
      (s) => s.value == stackStr,
      orElse: () => DeveloperStack.frontend,
    );

    DateTime parseDate(dynamic val) {
      if (val is String) {
        return DateTime.tryParse(val) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return UserProfile(
      id: docId ?? (map['id'] as String? ?? ''),
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: role,
      stack: stack,
      teamId: map['teamId'] as String?,
      assignedModules: List<String>.from(map['assignedModules'] as List? ?? const []),
      avatarUrl: map['avatarUrl'] as String?,
      isActive: map['isActive'] as bool? ?? true,
      lastActiveAt: parseDate(map['lastActiveAt']),
      createdAt: parseDate(map['createdAt']),
    );
  }
}
