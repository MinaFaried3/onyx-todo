import 'package:equatable/equatable.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_history_item.dart';

class TaskEntity extends Equatable {
  final String id;
  final String formattedId; // e.g., "V5.1.8.GNR.000028"
  final String version; // e.g., "V5.1.8"
  final String moduleCode; // e.g., "GNR"
  final int sequenceNumber; // e.g., 28
  final String screenName; // e.g., "شاشة الدخول"
  final String title;
  final String description;
  final TaskType taskType;
  final TaskPriority priority;
  final TaskStatus status;
  final String? backendDevName;
  final String? frontendDevName;
  final String? middleDevName;
  final String? qaTesterName;
  final DateTime createdDate;
  final DateTime? dueDate;
  final DateTime? resolvedDate;
  final double estimatedHours;
  final double actualHours;
  final String? devNotes;
  final String? qaNotes;
  final List<TaskHistoryItem> history;

  const TaskEntity({
    required this.id,
    required this.formattedId,
    required this.version,
    required this.moduleCode,
    required this.sequenceNumber,
    required this.screenName,
    required this.title,
    this.description = '',
    this.taskType = TaskType.task,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.open,
    this.backendDevName,
    this.frontendDevName,
    this.middleDevName,
    this.qaTesterName,
    required this.createdDate,
    this.dueDate,
    this.resolvedDate,
    this.estimatedHours = 0.0,
    this.actualHours = 0.0,
    this.devNotes,
    this.qaNotes,
    this.history = const [],
  });

  /// Helper to format task ID pattern: `V<version>.<module>.<000000>`
  static String generateFormattedId({
    required String version,
    required String moduleCode,
    required int sequenceNumber,
  }) {
    final cleanVer = version.startsWith('V') ? version : 'V$version';
    final cleanMod = moduleCode.trim().toUpperCase();
    final seqStr = sequenceNumber.toString().padLeft(6, '0');
    return '$cleanVer.$cleanMod.$seqStr';
  }

  @override
  List<Object?> get props => [
        id,
        formattedId,
        version,
        moduleCode,
        sequenceNumber,
        screenName,
        title,
        description,
        taskType,
        priority,
        status,
        backendDevName,
        frontendDevName,
        middleDevName,
        qaTesterName,
        createdDate,
        dueDate,
        resolvedDate,
        estimatedHours,
        actualHours,
        devNotes,
        qaNotes,
        history,
      ];

  TaskEntity copyWith({
    String? id,
    String? formattedId,
    String? version,
    String? moduleCode,
    int? sequenceNumber,
    String? screenName,
    String? title,
    String? description,
    TaskType? taskType,
    TaskPriority? priority,
    TaskStatus? status,
    String? backendDevName,
    String? frontendDevName,
    String? middleDevName,
    String? qaTesterName,
    DateTime? createdDate,
    DateTime? dueDate,
    DateTime? resolvedDate,
    double? estimatedHours,
    double? actualHours,
    String? devNotes,
    String? qaNotes,
    List<TaskHistoryItem>? history,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      formattedId: formattedId ?? this.formattedId,
      version: version ?? this.version,
      moduleCode: moduleCode ?? this.moduleCode,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      screenName: screenName ?? this.screenName,
      title: title ?? this.title,
      description: description ?? this.description,
      taskType: taskType ?? this.taskType,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      backendDevName: backendDevName ?? this.backendDevName,
      frontendDevName: frontendDevName ?? this.frontendDevName,
      middleDevName: middleDevName ?? this.middleDevName,
      qaTesterName: qaTesterName ?? this.qaTesterName,
      createdDate: createdDate ?? this.createdDate,
      dueDate: dueDate ?? this.dueDate,
      resolvedDate: resolvedDate ?? this.resolvedDate,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      actualHours: actualHours ?? this.actualHours,
      devNotes: devNotes ?? this.devNotes,
      qaNotes: qaNotes ?? this.qaNotes,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'formattedId': formattedId,
      'version': version,
      'moduleCode': moduleCode,
      'sequenceNumber': sequenceNumber,
      'screenName': screenName,
      'title': title,
      'description': description,
      'taskType': taskType.value,
      'priority': priority.value,
      'status': status.value,
      'backendDevName': backendDevName,
      'frontendDevName': frontendDevName,
      'middleDevName': middleDevName,
      'qaTesterName': qaTesterName,
      'createdDate': createdDate.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'resolvedDate': resolvedDate?.toIso8601String(),
      'estimatedHours': estimatedHours,
      'actualHours': actualHours,
      'devNotes': devNotes,
      'qaNotes': qaNotes,
      'history': history.map((e) => e.toMap()).toList(),
    };
  }

  factory TaskEntity.fromMap(Map<String, dynamic> map, [String? docId]) {
    return TaskEntity(
      id: docId ?? (map['id'] as String? ?? ''),
      formattedId: map['formattedId'] as String? ?? '',
      version: map['version'] as String? ?? 'V5.1.8',
      moduleCode: map['moduleCode'] as String? ?? 'GNR',
      sequenceNumber: (map['sequenceNumber'] as num?)?.toInt() ?? 1,
      screenName: map['screenName'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      taskType: TaskType.fromString(map['taskType'] as String?),
      priority: TaskPriority.fromString(map['priority'] as String?),
      status: TaskStatus.fromString(map['status'] as String?),
      backendDevName: map['backendDevName'] as String?,
      frontendDevName: map['frontendDevName'] as String?,
      middleDevName: map['middleDevName'] as String?,
      qaTesterName: map['qaTesterName'] as String?,
      createdDate: map['createdDate'] != null
          ? DateTime.tryParse(map['createdDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      dueDate: map['dueDate'] != null
          ? DateTime.tryParse(map['dueDate'] as String)
          : null,
      resolvedDate: map['resolvedDate'] != null
          ? DateTime.tryParse(map['resolvedDate'] as String)
          : null,
      estimatedHours: (map['estimatedHours'] as num?)?.toDouble() ?? 0.0,
      actualHours: (map['actualHours'] as num?)?.toDouble() ?? 0.0,
      devNotes: map['devNotes'] as String?,
      qaNotes: map['qaNotes'] as String?,
      history: (map['history'] as List? ?? [])
          .map((e) => TaskHistoryItem.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}
