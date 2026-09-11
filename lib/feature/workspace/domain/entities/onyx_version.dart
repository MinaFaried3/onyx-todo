import 'package:equatable/equatable.dart';

class OnyxVersion extends Equatable {
  final String code; // e.g. "V5.1.8"
  final String name; // e.g. "Sprint 5.1.8"
  final bool isActive;
  final DateTime? releaseDate;
  final int totalTasks;

  const OnyxVersion({
    required this.code,
    required this.name,
    this.isActive = true,
    this.releaseDate,
    this.totalTasks = 0,
  });

  @override
  List<Object?> get props => [code, name, isActive, releaseDate, totalTasks];

  OnyxVersion copyWith({
    String? code,
    String? name,
    bool? isActive,
    DateTime? releaseDate,
    int? totalTasks,
  }) {
    return OnyxVersion(
      code: code ?? this.code,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      releaseDate: releaseDate ?? this.releaseDate,
      totalTasks: totalTasks ?? this.totalTasks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'isActive': isActive,
      'releaseDate': releaseDate?.toIso8601String(),
      'totalTasks': totalTasks,
    };
  }

  factory OnyxVersion.fromMap(Map<String, dynamic> map) {
    return OnyxVersion(
      code: map['code'] as String? ?? 'V5.1.8',
      name: map['name'] as String? ?? 'V5.1.8',
      isActive: map['isActive'] as bool? ?? true,
      releaseDate: map['releaseDate'] != null
          ? DateTime.tryParse(map['releaseDate'] as String)
          : null,
      totalTasks: (map['totalTasks'] as num?)?.toInt() ?? 0,
    );
  }

  static const List<OnyxVersion> defaultVersions = [
    OnyxVersion(code: 'V5.1.8', name: 'Release V5.1.8', isActive: true),
    OnyxVersion(code: 'V5.2.0', name: 'Next V5.2.0', isActive: false),
    OnyxVersion(code: 'Backlog', name: 'Product Backlog', isActive: false),
  ];
}
