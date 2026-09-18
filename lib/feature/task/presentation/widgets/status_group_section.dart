import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/core/ui/responsive/responsive_extension.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/assignee_avatar_badge.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/clickup_status_ring.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_mobile_card_tile.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_priority_flag.dart';

class StatusGroupSection extends HookWidget {
  final String title;
  final TaskStatus? status;
  final String? assigneeName;
  final List<TaskEntity> tasks;
  final bool isDark;
  final ValueChanged<TaskEntity> onTaskTap;
  final void Function(TaskEntity task, TaskStatus newStatus) onStatusChanged;
  final VoidCallback? onAddTask;

  const StatusGroupSection({
    super.key,
    required this.title,
    this.status,
    this.assigneeName,
    required this.tasks,
    required this.isDark,
    required this.onTaskTap,
    required this.onStatusChanged,
    this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(true);
    final isMobile = context.isMobile;

    final groupColor = status != null
        ? status!.color
        : (assigneeName != null ? OnyxColors.getAvatarColor(assigneeName!) : OnyxColors.primary);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? OnyxColors.darkCard : OnyxColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── ClickUp Group Header Bar ──────────────────────────────────────────
          InkWell(
            onTap: () => isExpanded.value = !isExpanded.value,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: isDark
                    ? groupColor.withValues(alpha: 0.1)
                    : groupColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(8),
                  bottom: Radius.circular(isExpanded.value ? 0 : 8),
                ),
              ),
              child: Row(
                children: [
                  FaIcon(
                    isExpanded.value ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronRight,
                    size: 11,
                    color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
                  ),
                  const SizedBox(width: 8),

                  if (assigneeName != null) ...[
                    AssigneeAvatarBadge(name: assigneeName!, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      assigneeName!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: groupColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: groupColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            title.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: groupColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(width: 8),
                  Text(
                    '${tasks.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                    ),
                  ),

                  const Spacer(),
                  if (onAddTask != null)
                    InkWell(
                      onTap: onAddTask,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(FontAwesomeIcons.plus, size: 10, color: OnyxColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              AppStrings.add.tr(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: OnyxColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ─── Table Column Headers (Desktop/Tablet only) ───────────────────────
          if (isExpanded.value) ...[
            if (!isMobile)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? OnyxColors.darkSidebar : OnyxColors.neutral50,
                  border: Border(
                    top: BorderSide(
                      color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                      width: 0.5,
                    ),
                    bottom: BorderSide(
                      color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 28), // space for status ring
                    SizedBox(
                      width: 180,
                      child: Text(
                        AppStrings.taskId.tr(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        AppStrings.taskTitle.tr(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: Text(
                        AppStrings.assignees.tr(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 85,
                      child: Text(
                        AppStrings.dueDate.tr(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 75,
                      child: Text(
                        AppStrings.priority.tr(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // ─── Task Content: Mobile Cards vs Desktop Rows ───────────────────────
            if (isMobile)
              ...tasks.map(
                (task) => TaskMobileCardTile(
                  task: task,
                  isDark: isDark,
                  onTaskTap: onTaskTap,
                  onStatusChanged: onStatusChanged,
                ),
              )
            else
              ...tasks.map((task) {
                final devName = task.frontendDevName ?? task.backendDevName ?? task.middleDevName ?? 'Unassigned';
                final hasDueDate = task.dueDate != null;
                final isOverdue = hasDueDate && task.dueDate!.isBefore(DateTime.now());

                return InkWell(
                  onTap: () => onTaskTap(task),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // ClickUp Status Ring
                      ClickUpStatusRing(
                        status: task.status,
                        size: 17,
                        onTap: () {
                          // Quick cycle next status
                          final nextStatus = switch (task.status) {
                            TaskStatus.open => TaskStatus.inProgress,
                            TaskStatus.inProgress => TaskStatus.backendSolved,
                            TaskStatus.backendSolved => TaskStatus.qaTesting,
                            TaskStatus.qaTesting => TaskStatus.closed,
                            _ => TaskStatus.open,
                          };
                          onStatusChanged(task, nextStatus);
                        },
                      ),
                      const SizedBox(width: 10),

                      // Task ID Badge Column
                      SizedBox(
                        width: 180,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TaskIdBadge(
                            formattedId: task.displayId,
                            onTap: () => onTaskTap(task),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Task Title & Tags
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                task.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                                  decoration: task.status == TaskStatus.closed ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                            if (task.screenName.isNotEmpty) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: isDark ? OnyxColors.neutral800 : OnyxColors.neutral100,
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(
                                    color: isDark ? OnyxColors.neutral700 : OnyxColors.neutral200,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  task.screenName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral600,
                                  ),
                                ),
                              ),
                            ],
                            if (task.totalSubtasks > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: task.completedSubtasks == task.totalSubtasks
                                      ? OnyxColors.success.withValues(alpha: 0.12)
                                      : (isDark ? OnyxColors.neutral800 : OnyxColors.neutral100),
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(
                                    color: task.completedSubtasks == task.totalSubtasks
                                        ? OnyxColors.success.withValues(alpha: 0.4)
                                        : (isDark ? OnyxColors.neutral700 : OnyxColors.neutral200),
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.diagramProject,
                                      size: 9,
                                      color: task.completedSubtasks == task.totalSubtasks
                                          ? OnyxColors.success
                                          : (isDark ? OnyxColors.neutral400 : OnyxColors.neutral600),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${task.completedSubtasks}/${task.totalSubtasks}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: task.completedSubtasks == task.totalSubtasks
                                            ? OnyxColors.success
                                            : (isDark ? OnyxColors.neutral300 : OnyxColors.neutral600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(width: 6),
                            FaIcon(
                              FontAwesomeIcons.paperclip,
                              size: 10,
                              color: isDark ? OnyxColors.neutral500 : OnyxColors.neutral400,
                            ),
                          ],
                        ),
                      ),

                      // Assignee Avatar
                      SizedBox(
                        width: 90,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AssigneeAvatarBadge(name: devName, size: 22),
                        ),
                      ),

                      // Due Date
                      SizedBox(
                        width: 85,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: hasDueDate
                              ? Text(
                                  DateFormat('M/d/yy').format(task.dueDate!),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                                    color: isOverdue
                                        ? OnyxColors.danger
                                        : (isDark ? OnyxColors.neutral400 : OnyxColors.neutral600),
                                  ),
                                )
                              : FaIcon(
                                  FontAwesomeIcons.calendar,
                                  size: 12,
                                  color: isDark ? OnyxColors.neutral600 : OnyxColors.neutral400,
                                ),
                        ),
                      ),

                      // Priority Flag & Text
                      SizedBox(
                        width: 75,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TaskPriorityFlag(
                            priority: task.priority,
                            onPriorityChanged: (_) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            // ─── Inline "+ Add Task" Row ──────────────────────────────────────────
            InkWell(
              onTap: onAddTask,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.plus, size: 11, color: OnyxColors.neutral400),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.addTask.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
