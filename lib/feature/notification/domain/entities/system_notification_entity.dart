import 'package:equatable/equatable.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';

class SystemNotificationEntity extends Equatable {
  final String id;
  final String recipientUserId;
  final String? taskId;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;

  SystemNotificationEntity({
    required this.id,
    required this.recipientUserId,
    this.taskId,
    required this.title,
    required this.message,
    this.type = NotificationType.systemAnnouncement,
    this.isRead = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  List<Object?> get props => [
        id,
        recipientUserId,
        taskId,
        title,
        message,
        type,
        isRead,
        createdAt,
      ];

  SystemNotificationEntity copyWith({
    String? id,
    String? recipientUserId,
    String? taskId,
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return SystemNotificationEntity(
      id: id ?? this.id,
      recipientUserId: recipientUserId ?? this.recipientUserId,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipientUserId': recipientUserId,
      'taskId': taskId,
      'title': title,
      'message': message,
      'type': type.value,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SystemNotificationEntity.fromMap(Map<String, dynamic> map, [String? docId]) {
    final typeStr = map['type'] as String? ?? 'system_announcement';
    final type = NotificationType.values.firstWhere(
      (t) => t.value == typeStr,
      orElse: () => NotificationType.systemAnnouncement,
    );

    DateTime parseDate(dynamic val) {
      if (val is String) {
        return DateTime.tryParse(val) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return SystemNotificationEntity(
      id: docId ?? (map['id'] as String? ?? ''),
      recipientUserId: map['recipientUserId'] as String? ?? 'ALL',
      taskId: map['taskId'] as String?,
      title: map['title'] as String? ?? '',
      message: map['message'] as String? ?? '',
      type: type,
      isRead: map['isRead'] as bool? ?? false,
      createdAt: parseDate(map['createdAt']),
    );
  }
}
