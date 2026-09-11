import 'package:equatable/equatable.dart';

class TaskSubtask extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;
  final String? assignedTo;
  final double estimatedHours;
  final DateTime createdAt;
  final DateTime? completedAt;

  const TaskSubtask({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.assignedTo,
    this.estimatedHours = 0.0,
    required this.createdAt,
    this.completedAt,
  });

  TaskSubtask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    String? assignedTo,
    double? estimatedHours,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TaskSubtask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      assignedTo: assignedTo ?? this.assignedTo,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'assignedTo': assignedTo,
      'estimatedHours': estimatedHours,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory TaskSubtask.fromMap(Map<String, dynamic> map) {
    return TaskSubtask(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      isCompleted: map['isCompleted'] as bool? ?? false,
      assignedTo: map['assignedTo'] as String?,
      estimatedHours: (map['estimatedHours'] as num?)?.toDouble() ?? 0.0,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        isCompleted,
        assignedTo,
        estimatedHours,
        createdAt,
        completedAt,
      ];
}
