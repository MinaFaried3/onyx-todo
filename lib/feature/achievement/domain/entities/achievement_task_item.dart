import 'package:equatable/equatable.dart';

class AchievementTaskItem extends Equatable {
  final String taskId;
  final String formattedId; // e.g. "V5.1.8.GLS.000001"
  final String title;
  final String moduleCode;
  final String screenName;
  final double hoursSpent;
  final String status;
  final String? notes;

  const AchievementTaskItem({
    required this.taskId,
    required this.formattedId,
    required this.title,
    required this.moduleCode,
    required this.screenName,
    required this.hoursSpent,
    required this.status,
    this.notes,
  });

  @override
  List<Object?> get props => [
        taskId,
        formattedId,
        title,
        moduleCode,
        screenName,
        hoursSpent,
        status,
        notes,
      ];

  AchievementTaskItem copyWith({
    String? taskId,
    String? formattedId,
    String? title,
    String? moduleCode,
    String? screenName,
    double? hoursSpent,
    String? status,
    String? notes,
  }) {
    return AchievementTaskItem(
      taskId: taskId ?? this.taskId,
      formattedId: formattedId ?? this.formattedId,
      title: title ?? this.title,
      moduleCode: moduleCode ?? this.moduleCode,
      screenName: screenName ?? this.screenName,
      hoursSpent: hoursSpent ?? this.hoursSpent,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'formattedId': formattedId,
      'title': title,
      'moduleCode': moduleCode,
      'screenName': screenName,
      'hoursSpent': hoursSpent,
      'status': status,
      'notes': notes,
    };
  }

  factory AchievementTaskItem.fromMap(Map<String, dynamic> map) {
    return AchievementTaskItem(
      taskId: map['taskId'] as String? ?? '',
      formattedId: map['formattedId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      moduleCode: map['moduleCode'] as String? ?? '',
      screenName: map['screenName'] as String? ?? '',
      hoursSpent: (map['hoursSpent'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] as String? ?? 'in_progress',
      notes: map['notes'] as String?,
    );
  }
}
