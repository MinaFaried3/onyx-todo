import 'package:equatable/equatable.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final DeveloperStack stack;
  final List<String> assignedModules;
  final String? avatarUrl;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.developer,
    this.stack = DeveloperStack.frontend,
    this.assignedModules = const [],
    this.avatarUrl,
  });

  bool get isDepartmentManager => role == UserRole.departmentManager;
  bool get isFrontendLead => role == UserRole.frontendLead;
  bool get isLeader => isDepartmentManager || isFrontendLead;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        role,
        stack,
        assignedModules,
        avatarUrl,
      ];

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    DeveloperStack? stack,
    List<String>? assignedModules,
    String? avatarUrl,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      stack: stack ?? this.stack,
      assignedModules: assignedModules ?? this.assignedModules,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.value,
      'stack': stack.value,
      'assignedModules': assignedModules,
      'avatarUrl': avatarUrl,
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

    return UserProfile(
      id: docId ?? (map['id'] as String? ?? ''),
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      role: role,
      stack: stack,
      assignedModules: List<String>.from(map['assignedModules'] as List? ?? const []),
      avatarUrl: map['avatarUrl'] as String?,
    );
  }

  /// Default demo / sample users matching the Onyx ERP team structure
  static const List<UserProfile> demoUsers = [
    UserProfile(
      id: 'dm_1',
      name: 'مدير الإدارة (Department Manager)',
      email: 'manager@onyx.com',
      role: UserRole.departmentManager,
      stack: DeveloperStack.backend,
      assignedModules: ['*'],
    ),
    UserProfile(
      id: 'fl_1',
      name: 'علي بن جحلان (Frontend Lead)',
      email: 'ali@onyx.com',
      role: UserRole.frontendLead,
      stack: DeveloperStack.frontend,
      assignedModules: ['ADM', 'GNR', 'GLS', 'CRM', 'INV'],
    ),
    UserProfile(
      id: 'be_1',
      name: 'Alkholi (Backend Senior)',
      email: 'alkholi@onyx.com',
      role: UserRole.developer,
      stack: DeveloperStack.backend,
      assignedModules: ['ADM', 'GNR'],
    ),
    UserProfile(
      id: 'be_2',
      name: 'Mahmoud Salah (Backend)',
      email: 'mahmoud@onyx.com',
      role: UserRole.developer,
      stack: DeveloperStack.backend,
      assignedModules: ['ADM', 'GLS', 'APS'],
    ),
    UserProfile(
      id: 'fe_1',
      name: 'nader (Frontend)',
      email: 'nader@onyx.com',
      role: UserRole.developer,
      stack: DeveloperStack.frontend,
      assignedModules: ['ADM', 'GLS'],
    ),
    UserProfile(
      id: 'fe_2',
      name: 'حسين (Frontend)',
      email: 'hussein@onyx.com',
      role: UserRole.developer,
      stack: DeveloperStack.frontend,
      assignedModules: ['ADM', 'CRM', 'POS'],
    ),
    UserProfile(
      id: 'be_3',
      name: 'Shrouk (Backend)',
      email: 'shrouk@onyx.com',
      role: UserRole.developer,
      stack: DeveloperStack.backend,
      assignedModules: ['ADM', 'CRM'],
    ),
  ];
}
