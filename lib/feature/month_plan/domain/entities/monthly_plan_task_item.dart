import 'package:equatable/equatable.dart';

class MonthlyPlanTaskItem extends Equatable {
  final String taskId;
  final String formattedId;
  final String title;
  final String moduleCode;
  final String screenName;
  final double estimatedDays;
  final double estimatedHours;
  final double actualHours;
  final String status;

  const MonthlyPlanTaskItem({
    required this.taskId,
    required this.formattedId,
    required this.title,
    required this.moduleCode,
    required this.screenName,
    this.estimatedDays = 1.0,
    this.estimatedHours = 8.0,
    this.actualHours = 0.0,
    this.status = 'open',
  });

  @override
  List<Object?> get props => [
        taskId,
        formattedId,
        title,
        moduleCode,
        screenName,
        estimatedDays,
        estimatedHours,
        actualHours,
        status,
      ];

  MonthlyPlanTaskItem copyWith({
    String? taskId,
    String? formattedId,
    String? title,
    String? moduleCode,
    String? screenName,
    double? estimatedDays,
    double? estimatedHours,
    double? actualHours,
    String? status,
  }) {
    return MonthlyPlanTaskItem(
      taskId: taskId ?? this.taskId,
      formattedId: formattedId ?? this.formattedId,
      title: title ?? this.title,
      moduleCode: moduleCode ?? this.moduleCode,
      screenName: screenName ?? this.screenName,
      estimatedDays: estimatedDays ?? this.estimatedDays,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      actualHours: actualHours ?? this.actualHours,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'formattedId': formattedId,
      'title': title,
      'moduleCode': moduleCode,
      'screenName': screenName,
      'estimatedDays': estimatedDays,
      'estimatedHours': estimatedHours,
      'actualHours': actualHours,
      'status': status,
    };
  }

  factory MonthlyPlanTaskItem.fromMap(Map<String, dynamic> map) {
    return MonthlyPlanTaskItem(
      taskId: map['taskId'] as String? ?? '',
      formattedId: map['formattedId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      moduleCode: map['moduleCode'] as String? ?? '',
      screenName: map['screenName'] as String? ?? '',
      estimatedDays: (map['estimatedDays'] as num?)?.toDouble() ?? 1.0,
      estimatedHours: (map['estimatedHours'] as num?)?.toDouble() ?? 8.0,
      actualHours: (map['actualHours'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] as String? ?? 'open',
    );
  }
}
