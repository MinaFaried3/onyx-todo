import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/auth/domain/entities/user_profile.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';

class RolePipelineCard extends StatelessWidget {
  final TaskEntity task;
  final UserProfile currentUser;
  final bool isDark;
  final void Function(String newSubStatus) onUpdateSubStatus;
  final void Function(String newStage) onManualStageChange;

  const RolePipelineCard({
    super.key,
    required this.task,
    required this.currentUser,
    required this.isDark,
    required this.onUpdateSubStatus,
    required this.onManualStageChange,
  });

  @override
  Widget build(BuildContext context) {
    final isMyTurn = task.isUserTurnToWork(currentUser);
    final activeStageIndex = task.roleFlow.indexOf(task.currentRoleStage);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? OnyxColors.darkBackground : OnyxColors.neutral100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Role Flow Pipeline & Manager Override
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.diagramProject, size: 13, color: OnyxColors.primary),
              const SizedBox(width: 8),
              Text(
                context.locale.languageCode == 'ar'
                    ? 'مسار تسليم الأدوار (Sequential Role Flow)'
                    : 'Sequential Role Execution Flow',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                ),
              ),
              const Spacer(),
              if (currentUser.isDepartmentManager)
                PopupMenuButton<String>(
                  tooltip: 'Manager Stage Override',
                  icon: const FaIcon(FontAwesomeIcons.sliders, size: 11, color: OnyxColors.neutral400),
                  onSelected: onManualStageChange,
                  itemBuilder: (ctx) => task.roleFlow.map((r) {
                    return PopupMenuItem(
                      value: r,
                      child: Text('Jump to $r stage', style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Role Stages Row
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              for (int i = 0; i < task.roleFlow.length; i++) ...[
                _buildStageChip(
                  role: task.roleFlow[i],
                  index: i,
                  isActive: task.roleFlow[i] == task.currentRoleStage,
                  isCompleted: activeStageIndex > i || task.status.value == 'closed',
                  assignee: _getAssigneeForRole(task.roleFlow[i]),
                  context: context,
                ),
                if (i < task.roleFlow.length - 1)
                  const FaIcon(FontAwesomeIcons.arrowRight, size: 9, color: OnyxColors.neutral400),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Role Sub-status Execution Controls
          if (task.status.value != 'closed') ...[
            if (isMyTurn) ...[
              Text(
                context.locale.languageCode == 'ar'
                    ? 'حالة مرحلة (${task.currentRoleStage}):'
                    : 'Stage (${task.currentRoleStage}) Status:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(context.locale.languageCode == 'ar' ? 'انتظار (Todo)' : 'Todo', style: const TextStyle(fontSize: 11)),
                    selected: task.roleSubStatus == 'todo',
                    onSelected: (_) => onUpdateSubStatus('todo'),
                  ),
                  ChoiceChip(
                    label: Text(context.locale.languageCode == 'ar' ? 'قيد التنفيذ' : 'In Progress', style: const TextStyle(fontSize: 11)),
                    selected: task.roleSubStatus == 'in_progress',
                    selectedColor: OnyxColors.warning.withValues(alpha: 0.25),
                    onSelected: (_) => onUpdateSubStatus('in_progress'),
                  ),
                  ChoiceChip(
                    label: Text(context.locale.languageCode == 'ar' ? 'قيد المراجعة' : 'Under Review', style: const TextStyle(fontSize: 11)),
                    selected: task.roleSubStatus == 'under_review',
                    selectedColor: OnyxColors.info.withValues(alpha: 0.25),
                    onSelected: (_) => onUpdateSubStatus('under_review'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnyxColors.success,
                      foregroundColor: OnyxColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    icon: const FaIcon(FontAwesomeIcons.check, size: 10),
                    label: Text(
                      task.nextRoleStage != null
                          ? (context.locale.languageCode == 'ar' ? 'اكتمل وترحيل ➔' : 'Complete & Handoff ➔')
                          : (context.locale.languageCode == 'ar' ? 'إغلاق المهمة' : 'Complete Task'),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => onUpdateSubStatus('completed'),
                  ),
                ],
              ),
            ] else ...[
              // Waiting Notice for next stages
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: OnyxColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: OnyxColors.warning.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.clockRotateLeft, size: 11, color: OnyxColors.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.locale.languageCode == 'ar'
                            ? 'في انتظار إنجاز مرحلة (${task.currentRoleStage}) بواسطة (${task.currentAssigneeName ?? "المطور المسند"})'
                            : 'Waiting for stage (${task.currentRoleStage}) completion by (${task.currentAssigneeName ?? "assigned dev"})',
                        style: const TextStyle(fontSize: 11, color: OnyxColors.warning, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildStageChip({
    required String role,
    required int index,
    required bool isActive,
    required bool isCompleted,
    required String? assignee,
    required BuildContext context,
  }) {
    final Color color = isCompleted
        ? OnyxColors.success
        : (isActive ? OnyxColors.primary : (isDark ? OnyxColors.neutral600 : OnyxColors.neutral400));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? OnyxColors.primary.withValues(alpha: 0.15)
            : (isDark ? OnyxColors.darkCard : OnyxColors.white),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? OnyxColors.primary : (isCompleted ? OnyxColors.success : (isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder)),
          width: isActive ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCompleted)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: FaIcon(FontAwesomeIcons.check, size: 9, color: OnyxColors.success),
            )
          else if (isActive)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 4),
              decoration: const BoxDecoration(color: OnyxColors.primary, shape: BoxShape.circle),
            ),
          Text(
            role.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
          if (assignee != null && assignee.isNotEmpty) ...[
            Text(' • ', style: TextStyle(fontSize: 9, color: OnyxColors.neutral400)),
            Text(
              assignee,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String? _getAssigneeForRole(String role) {
    return switch (role.toLowerCase()) {
      'backend' => task.backendDevName,
      'middle' => task.middleDevName,
      'frontend' => task.frontendDevName,
      'qa' => task.qaTesterName,
      _ => null,
    };
  }
}
