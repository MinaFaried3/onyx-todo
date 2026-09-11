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
  final DateTime? startDate;
  final DateTime? endDate;
  final String? description;
  final String? logicDelivered;
  final bool isRolledOver;

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
    this.startDate,
    this.endDate,
    this.description,
    this.logicDelivered,
    this.isRolledOver = false,
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
        startDate,
        endDate,
        description,
        logicDelivered,
        isRolledOver,
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
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    String? logicDelivered,
    bool? isRolledOver,
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
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      logicDelivered: logicDelivered ?? this.logicDelivered,
      isRolledOver: isRolledOver ?? this.isRolledOver,
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
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'description': description,
      'logicDelivered': logicDelivered,
      'isRolledOver': isRolledOver,
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
      startDate: map['startDate'] != null
          ? DateTime.tryParse(map['startDate'] as String)
          : null,
      endDate: map['endDate'] != null
          ? DateTime.tryParse(map['endDate'] as String)
          : null,
      description: map['description'] as String?,
      logicDelivered: map['logicDelivered'] as String?,
      isRolledOver: map['isRolledOver'] as bool? ?? false,
    );
  }
}
