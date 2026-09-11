import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:easy_localization/easy_localization.dart';

enum TaskStatus {
  open('open'),
  inProgress('in_progress'),
  backendSolved('backend_solved'),
  frontendSolved('frontend_solved'),
  qaTesting('qa_testing'),
  closed('closed');

  final String value;
  const TaskStatus(this.value);

  String get label => switch (this) {
        open => AppStrings.statusOpen.tr(),
        inProgress => AppStrings.statusInProgress.tr(),
        backendSolved => AppStrings.statusBackendSolved.tr(),
        frontendSolved => AppStrings.statusFrontendSolved.tr(),
        qaTesting => AppStrings.statusQaTesting.tr(),
        closed => AppStrings.statusClosed.tr(),
      };

  Color get color => switch (this) {
        open => OnyxColors.statusOpen,
        inProgress => OnyxColors.statusInProgress,
        backendSolved => OnyxColors.statusBackendSolved,
        frontendSolved => OnyxColors.statusFrontendSolved,
        qaTesting => OnyxColors.statusQaTesting,
        closed => OnyxColors.statusClosed,
      };

  static TaskStatus fromString(String? val) {
    if (val == null) return TaskStatus.open;
    final clean = val.trim().toLowerCase();
    if (clean.contains('تم الحل') || clean == 'backend_solved' || clean == 'solved') {
      return TaskStatus.backendSolved;
    }
    if (clean == 'frontend_solved') return TaskStatus.frontendSolved;
    if (clean.contains('فحص') || clean == 'qa_testing' || clean == 'testing') {
      return TaskStatus.qaTesting;
    }
    if (clean.contains('مغلق') || clean == 'closed' || clean == 'done') {
      return TaskStatus.closed;
    }
    if (clean.contains('تنفيذ') || clean == 'in_progress' || clean == 'progress') {
      return TaskStatus.inProgress;
    }
    return TaskStatus.open;
  }
}

enum TaskPriority {
  urgent('urgent'),
  high('high'),
  medium('medium'),
  low('low');

  final String value;
  const TaskPriority(this.value);

  String get label => switch (this) {
        urgent => AppStrings.priorityUrgent.tr(),
        high => AppStrings.priorityHigh.tr(),
        medium => AppStrings.priorityMedium.tr(),
        low => AppStrings.priorityLow.tr(),
      };

  Color get color => switch (this) {
        urgent => OnyxColors.priorityUrgent,
        high => OnyxColors.priorityHigh,
        medium => OnyxColors.priorityMedium,
        low => OnyxColors.priorityLow,
      };

  FaIconData get icon => switch (this) {
        urgent => FontAwesomeIcons.fire,
        high => FontAwesomeIcons.flag,
        medium => FontAwesomeIcons.flag,
        low => FontAwesomeIcons.flag,
      };

  static TaskPriority fromString(String? val) {
    if (val == null) return TaskPriority.medium;
    final clean = val.trim().toLowerCase();
    if (clean.contains('عاجل') || clean == 'urgent') return TaskPriority.urgent;
    if (clean.contains('عالي') || clean == 'high') return TaskPriority.high;
    if (clean.contains('منخفض') || clean == 'low') return TaskPriority.low;
    return TaskPriority.medium;
  }
}

enum TaskType {
  task('task'),
  bug('bug'),
  feature('feature'),
  urgent('urgent');

  final String value;
  const TaskType(this.value);

  String get label => switch (this) {
        task => AppStrings.typeTask.tr(),
        bug => AppStrings.typeBug.tr(),
        feature => AppStrings.typeFeature.tr(),
        urgent => AppStrings.typeUrgent.tr(),
      };

  FaIconData get icon => switch (this) {
        task => FontAwesomeIcons.circleCheck,
        bug => FontAwesomeIcons.bug,
        feature => FontAwesomeIcons.star,
        urgent => FontAwesomeIcons.triangleExclamation,
      };

  Color get color => switch (this) {
        task => OnyxColors.primary,
        bug => OnyxColors.danger,
        feature => OnyxColors.success,
        urgent => OnyxColors.warning,
      };

  static TaskType fromString(String? val) {
    if (val == null) return TaskType.task;
    final clean = val.trim().toLowerCase();
    if (clean.contains('bug') || clean.contains('خطأ') || clean.contains('مشكلة')) {
      return TaskType.bug;
    }
    if (clean.contains('feature') || clean.contains('ميزة')) {
      return TaskType.feature;
    }
    if (clean.contains('urgent') || clean.contains('طارئ')) {
      return TaskType.urgent;
    }
    return TaskType.task;
  }
}

enum PlanStatus {
  draft('draft'),
  submitted('submitted'),
  approved('approved'),
  rejected('rejected'),
  closed('closed');

  final String value;
  const PlanStatus(this.value);

  String get label => switch (this) {
        draft => AppStrings.planDraft.tr(),
        submitted => AppStrings.planSubmitted.tr(),
        approved => AppStrings.planApproved.tr(),
        rejected => AppStrings.planRejected.tr(),
        closed => AppStrings.planClosed.tr(),
      };

  Color get color => switch (this) {
        draft => const Color(0xFF95A5A6),
        submitted => const Color(0xFF3498DB),
        approved => const Color(0xFF27AE60),
        rejected => const Color(0xFFE74C3C),
        closed => const Color(0xFF8E44AD),
      };
}

enum UserRole {
  departmentManager('department_manager'),
  teamLead('team_lead'),
  frontendLead('frontend_lead'),
  backend('backend'),
  frontend('frontend'),
  middle('middle'),
  qa('qa'),
  developer('developer');

  final String value;
  const UserRole(this.value);

  String get label => switch (this) {
        departmentManager => AppStrings.roleManager.tr(),
        teamLead => AppStrings.roleTeamLead.tr(),
        frontendLead => AppStrings.roleLead.tr(),
        backend => AppStrings.stackBackend.tr(),
        frontend => AppStrings.stackFrontend.tr(),
        middle => AppStrings.stackMiddle.tr(),
        qa => AppStrings.roleQa.tr(),
        developer => AppStrings.roleDeveloper.tr(),
      };
}

enum DeveloperStack {
  frontend('frontend'),
  backend('backend'),
  middle('middle'),
  qa('qa');

  final String value;
  const DeveloperStack(this.value);

  String get label => switch (this) {
        frontend => AppStrings.stackFrontend.tr(),
        backend => AppStrings.stackBackend.tr(),
        middle => AppStrings.stackMiddle.tr(),
        qa => AppStrings.roleQa.tr(),
      };
}

enum NotificationType {
  taskAssigned('task_assigned'),
  statusChanged('status_changed'),
  systemAnnouncement('system_announcement');

  final String value;
  const NotificationType(this.value);

  String get label => switch (this) {
        taskAssigned => AppStrings.notifTaskAssigned.tr(),
        statusChanged => AppStrings.notifStatusChanged.tr(),
        systemAnnouncement => AppStrings.notifSystem.tr(),
      };
}

