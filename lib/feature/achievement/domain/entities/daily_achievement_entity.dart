import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/feature/achievement/domain/entities/achievement_task_item.dart';

class DailyAchievementEntity extends Equatable {
  final String id;
  final String developerName;
  final DeveloperStack developerStack;
  final DateTime date;
  final List<AchievementTaskItem> tasksWorked;
  final double totalHours;
  final String? blockers;
  final String? nextDayPlan;
  final DateTime submittedAt;

  const DailyAchievementEntity({
    required this.id,
    required this.developerName,
    this.developerStack = DeveloperStack.frontend,
    required this.date,
    this.tasksWorked = const [],
    this.totalHours = 0.0,
    this.blockers,
    this.nextDayPlan,
    required this.submittedAt,
  });

  @override
  List<Object?> get props => [
        id,
        developerName,
        developerStack,
        date,
        tasksWorked,
        totalHours,
        blockers,
        nextDayPlan,
        submittedAt,
      ];

  DailyAchievementEntity copyWith({
    String? id,
    String? developerName,
    DeveloperStack? developerStack,
    DateTime? date,
    List<AchievementTaskItem>? tasksWorked,
    double? totalHours,
    String? blockers,
    String? nextDayPlan,
    DateTime? submittedAt,
  }) {
    return DailyAchievementEntity(
      id: id ?? this.id,
      developerName: developerName ?? this.developerName,
      developerStack: developerStack ?? this.developerStack,
      date: date ?? this.date,
      tasksWorked: tasksWorked ?? this.tasksWorked,
      totalHours: totalHours ?? this.totalHours,
      blockers: blockers ?? this.blockers,
      nextDayPlan: nextDayPlan ?? this.nextDayPlan,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }

  /// Generates the formatted WhatsApp achievement message
  String toWhatsAppSummary() {
    final dateStr = DateFormat('yyyy/MM/dd').format(date);
    final buffer = StringBuffer();
    buffer.writeln('🚀 *إنجاز اليوم* - $dateStr');
    buffer.writeln('👨‍💻 *المطور:* $developerName (${developerStack.label})');
    buffer.writeln('──────────────────');

    if (tasksWorked.isEmpty) {
      buffer.writeln('• لا توجد مهام مسجلة لهذا اليوم');
    } else {
      for (final t in tasksWorked) {
        final note = t.notes?.isNotEmpty == true ? ' - ${t.notes}' : '';
        buffer.writeln('🔹 *${t.formattedId}* [${t.moduleCode}] ${t.title}$note (${t.hoursSpent}h)');
      }
    }

    buffer.writeln('──────────────────');
    buffer.writeln('⏱ *إجمالي الساعات:* $totalHours ساعة');

    if (blockers != null && blockers!.trim().isNotEmpty) {
      buffer.writeln('⚠️ *العوائق:* $blockers');
    }
    if (nextDayPlan != null && nextDayPlan!.trim().isNotEmpty) {
      buffer.writeln('🎯 *خطة الغد:* $nextDayPlan');
    }

    return buffer.toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'developerName': developerName,
      'developerStack': developerStack.value,
      'date': date.toIso8601String(),
      'tasksWorked': tasksWorked.map((e) => e.toMap()).toList(),
      'totalHours': totalHours,
      'blockers': blockers,
      'nextDayPlan': nextDayPlan,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  factory DailyAchievementEntity.fromMap(Map<String, dynamic> map, [String? docId]) {
    final stackStr = map['developerStack'] as String? ?? 'frontend';
    final stack = DeveloperStack.values.firstWhere(
      (s) => s.value == stackStr,
      orElse: () => DeveloperStack.frontend,
    );

    return DailyAchievementEntity(
      id: docId ?? (map['id'] as String? ?? ''),
      developerName: map['developerName'] as String? ?? '',
      developerStack: stack,
      date: map['date'] != null
          ? DateTime.tryParse(map['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      tasksWorked: (map['tasksWorked'] as List? ?? [])
          .map((e) => AchievementTaskItem.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
      totalHours: (map['totalHours'] as num?)?.toDouble() ?? 0.0,
      blockers: map['blockers'] as String?,
      nextDayPlan: map['nextDayPlan'] as String?,
      submittedAt: map['submittedAt'] != null
          ? DateTime.tryParse(map['submittedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
