import 'package:equatable/equatable.dart';

class TeamEntity extends Equatable {
  final String id;
  final String name;
  final String? leaderId;
  final String? leaderName;
  final List<String> memberIds;
  final List<String> moduleCodes;
  final String? description;
  final List<String> roleFlow; // e.g. ['backend', 'middle', 'frontend', 'qa']
  final Map<String, String> defaultRoleAssignees; // role -> devName
  final DateTime createdAt;

  TeamEntity({
    required this.id,
    required this.name,
    this.leaderId,
    this.leaderName,
    this.memberIds = const [],
    this.moduleCodes = const [],
    this.description,
    this.roleFlow = const ['backend', 'middle', 'frontend', 'qa'],
    this.defaultRoleAssignees = const {},
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  List<Object?> get props => [
        id,
        name,
        leaderId,
        leaderName,
        memberIds,
        moduleCodes,
        description,
        roleFlow,
        defaultRoleAssignees,
        createdAt,
      ];

  TeamEntity copyWith({
    String? id,
    String? name,
    String? leaderId,
    String? leaderName,
    List<String>? memberIds,
    List<String>? moduleCodes,
    String? description,
    List<String>? roleFlow,
    Map<String, String>? defaultRoleAssignees,
    DateTime? createdAt,
  }) {
    return TeamEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      leaderId: leaderId ?? this.leaderId,
      leaderName: leaderName ?? this.leaderName,
      memberIds: memberIds ?? this.memberIds,
      moduleCodes: moduleCodes ?? this.moduleCodes,
      description: description ?? this.description,
      roleFlow: roleFlow ?? this.roleFlow,
      defaultRoleAssignees: defaultRoleAssignees ?? this.defaultRoleAssignees,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'leaderId': leaderId,
      'leaderName': leaderName,
      'memberIds': memberIds,
      'moduleCodes': moduleCodes,
      'description': description,
      'roleFlow': roleFlow,
      'defaultRoleAssignees': defaultRoleAssignees,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TeamEntity.fromMap(Map<String, dynamic> map, [String? docId]) {
    DateTime parseDate(dynamic val) {
      if (val is String) {
        return DateTime.tryParse(val) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return TeamEntity(
      id: docId ?? (map['id'] as String? ?? ''),
      name: map['name'] as String? ?? '',
      leaderId: map['leaderId'] as String?,
      leaderName: map['leaderName'] as String?,
      memberIds: List<String>.from(map['memberIds'] as List? ?? const []),
      moduleCodes: List<String>.from(map['moduleCodes'] as List? ?? const []),
      description: map['description'] as String?,
      roleFlow: List<String>.from(map['roleFlow'] as List? ?? const ['backend', 'middle', 'frontend', 'qa']),
      defaultRoleAssignees: Map<String, String>.from(map['defaultRoleAssignees'] as Map? ?? const {}),
      createdAt: parseDate(map['createdAt']),
    );
  }

  /// Default initial Onyx ERP teams
  static final List<TeamEntity> defaultTeams = [
    TeamEntity(
      id: 'team_core',
      name: 'فريق النظام الأساسي (Core ERP)',
      leaderId: 'fl_1',
      leaderName: 'علي بن جحلان',
      memberIds: const ['dm_1', 'fl_1', 'be_1'],
      moduleCodes: const ['ADM', 'GNR', 'GLS', 'SYS'],
      description: 'فريق إدارة البنية التحتية، الأمان، وإعدادات النظام العام',
      roleFlow: const ['backend', 'middle', 'frontend', 'qa'],
      defaultRoleAssignees: const {
        'backend': 'أحمد حسين',
        'middle': 'إسلام سليمان',
        'frontend': 'مينا فريد',
        'qa': 'عمر بن عميرة',
      },
    ),
    TeamEntity(
      id: 'team_sales',
      name: 'فريق المبيعات ونقاط البيع (Sales & POS)',
      leaderId: 'fl_1',
      leaderName: 'علي بن جحلان',
      memberIds: const ['be_2', 'fe_2'],
      moduleCodes: const ['POS', 'CRM', 'SLS', 'DIS'],
      description: 'إدارة فواتير المبيعات، عروض الأسعار، ونقاط البيع السحابية',
      roleFlow: const ['backend', 'frontend', 'qa'],
      defaultRoleAssignees: const {
        'backend': 'محمد سالم',
        'frontend': 'سارة أحمد',
        'qa': 'عمر بن عميرة',
      },
    ),
    TeamEntity(
      id: 'team_inventory',
      name: 'فريق المخازن والمشتريات (Inventory & Supply)',
      leaderId: 'fl_1',
      leaderName: 'علي بن جحلان',
      memberIds: const ['fe_1', 'be_3'],
      moduleCodes: const ['INV', 'PUR', 'WMS', 'MFG'],
      description: 'متابعة حركات الأصناف، الجرد، التوريد وأوامر الشراء',
      roleFlow: const ['backend', 'middle', 'frontend', 'qa'],
      defaultRoleAssignees: const {
        'backend': 'حسين ياسر',
        'middle': 'إسلام سليمان',
        'frontend': 'مينا فريد',
        'qa': 'عمر بن عميرة',
      },
    ),
  ];
}
