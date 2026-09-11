import 'package:equatable/equatable.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/feature/month_plan/domain/entities/monthly_plan_task_item.dart';

class MonthlyPlanEntity extends Equatable {
  final String id;
  final String developerName;
  final DeveloperStack developerStack;
  final int month;
  final int year;
  final int workingDays;
  final double targetHours;
  final double totalEstimatedHours;
  final double totalActualHours;
  final PlanStatus status;
  final String? managerNotes;
  final List<MonthlyPlanTaskItem> plannedTasks;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MonthlyPlanEntity({
    required this.id,
    required this.developerName,
    this.developerStack = DeveloperStack.frontend,
    required this.month,
    required this.year,
    this.workingDays = 20,
    this.targetHours = 160.0,
    this.totalEstimatedHours = 0.0,
    this.totalActualHours = 0.0,
    this.status = PlanStatus.draft,
    this.managerNotes,
    this.plannedTasks = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        developerName,
        developerStack,
        month,
        year,
        workingDays,
        targetHours,
        totalEstimatedHours,
        totalActualHours,
        status,
        managerNotes,
        plannedTasks,
        createdAt,
        updatedAt,
      ];

  MonthlyPlanEntity copyWith({
    String? id,
    String? developerName,
    DeveloperStack? developerStack,
    int? month,
    int? year,
    int? workingDays,
    double? targetHours,
    double? totalEstimatedHours,
    double? totalActualHours,
    PlanStatus? status,
    String? managerNotes,
    List<MonthlyPlanTaskItem>? plannedTasks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MonthlyPlanEntity(
      id: id ?? this.id,
      developerName: developerName ?? this.developerName,
      developerStack: developerStack ?? this.developerStack,
      month: month ?? this.month,
      year: year ?? this.year,
      workingDays: workingDays ?? this.workingDays,
      targetHours: targetHours ?? this.targetHours,
      totalEstimatedHours: totalEstimatedHours ?? this.totalEstimatedHours,
      totalActualHours: totalActualHours ?? this.totalActualHours,
      status: status ?? this.status,
      managerNotes: managerNotes ?? this.managerNotes,
      plannedTasks: plannedTasks ?? this.plannedTasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'developerName': developerName,
      'developerStack': developerStack.value,
      'month': month,
      'year': year,
      'workingDays': workingDays,
      'targetHours': targetHours,
      'totalEstimatedHours': totalEstimatedHours,
      'totalActualHours': totalActualHours,
      'status': status.value,
      'managerNotes': managerNotes,
      'plannedTasks': plannedTasks.map((e) => e.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory MonthlyPlanEntity.fromMap(Map<String, dynamic> map, [String? docId]) {
    final stackStr = map['developerStack'] as String? ?? 'frontend';
    final stack = DeveloperStack.values.firstWhere(
      (s) => s.value == stackStr,
      orElse: () => DeveloperStack.frontend,
    );
    final statusStr = map['status'] as String? ?? 'draft';
    final planStatus = PlanStatus.values.firstWhere(
      (s) => s.value == statusStr,
      orElse: () => PlanStatus.draft,
    );

    return MonthlyPlanEntity(
      id: docId ?? (map['id'] as String? ?? ''),
      developerName: map['developerName'] as String? ?? '',
      developerStack: stack,
      month: (map['month'] as num?)?.toInt() ?? DateTime.now().month,
      year: (map['year'] as num?)?.toInt() ?? DateTime.now().year,
      workingDays: (map['workingDays'] as num?)?.toInt() ?? 20,
      targetHours: (map['targetHours'] as num?)?.toDouble() ?? 160.0,
      totalEstimatedHours: (map['totalEstimatedHours'] as num?)?.toDouble() ?? 0.0,
      totalActualHours: (map['totalActualHours'] as num?)?.toDouble() ?? 0.0,
      status: planStatus,
      managerNotes: map['managerNotes'] as String?,
      plannedTasks: (map['plannedTasks'] as List? ?? [])
          .map((e) => MonthlyPlanTaskItem.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
