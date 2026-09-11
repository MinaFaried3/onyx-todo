import 'package:equatable/equatable.dart';

class TaskHistoryItem extends Equatable {
  final String id;
  final String action; // "status_change", "role_handoff", "reassigned", "comment", "created", "hours_logged"
  final String authorName;
  final DateTime timestamp;
  final String details;
  final String? roleStage;
  final String? fromStatus;
  final String? toStatus;

  const TaskHistoryItem({
    required this.id,
    required this.action,
    required this.authorName,
    required this.timestamp,
    required this.details,
    this.roleStage,
    this.fromStatus,
    this.toStatus,
  });

  @override
  List<Object?> get props => [
        id,
        action,
        authorName,
        timestamp,
        details,
        roleStage,
        fromStatus,
        toStatus,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'action': action,
      'authorName': authorName,
      'timestamp': timestamp.toIso8601String(),
      'details': details,
      'roleStage': roleStage,
      'fromStatus': fromStatus,
      'toStatus': toStatus,
    };
  }

  factory TaskHistoryItem.fromMap(Map<String, dynamic> map) {
    return TaskHistoryItem(
      id: map['id'] as String? ?? '',
      action: map['action'] as String? ?? '',
      authorName: map['authorName'] as String? ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      details: map['details'] as String? ?? '',
      roleStage: map['roleStage'] as String?,
      fromStatus: map['fromStatus'] as String?,
      toStatus: map['toStatus'] as String?,
    );
  }
}
