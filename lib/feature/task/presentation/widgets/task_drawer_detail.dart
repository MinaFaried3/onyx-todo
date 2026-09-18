import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/core/ui/responsive/responsive_extension.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/assignee_avatar_badge.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/role_pipeline_card.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_history_tile.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_subtasks_section.dart';

class TaskDrawerDetail extends HookWidget {
  final TaskEntity task;
  final VoidCallback onClose;

  const TaskDrawerDetail({
    super.key,
    required this.task,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final tasksCubit = context.tasksCubit;
    final workspaceCubit = context.workspaceCubit;
    final currentUser = workspaceCubit.state.currentUser;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleController = useTextEditingController(text: task.title);
    final isPreviewExpanded = useState<bool>(false);
    final isEditingTitle = useState<bool>(false);

    final isMobile = context.isMobile;
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = isMobile ? double.infinity : (screenWidth < 768 ? screenWidth * 0.95 : 580.0);

    final devName = task.frontendDevName ?? task.backendDevName ?? task.middleDevName ?? 'omer banaemh';
    final hasDueDate = task.dueDate != null;

    return Container(
      width: drawerWidth,
      decoration: BoxDecoration(
        color: isDark ? OnyxColors.darkCard : OnyxColors.white,
        border: Border(
          left: BorderSide(
            color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
            blurRadius: 24,
            offset: const Offset(-4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // ─── Top ClickUp Breadcrumb & Actions Bar ───────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                if (!isMobile) ...[
                  // Expand / Collapse icon
                  FaIcon(
                    FontAwesomeIcons.chevronUp,
                    size: 11,
                    color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                  ),
                  const SizedBox(width: 8),
                  FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 11,
                    color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                  ),
                  const SizedBox(width: 12),

                  // Purple O App Icon
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: OnyxColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        'O',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '/ Tasks',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                TaskIdBadge(
                  formattedId: task.displayId,
                ),
                if (!isMobile) ...[
                  const SizedBox(width: 6),
                  const FaIcon(FontAwesomeIcons.plus, size: 10, color: OnyxColors.neutral400),
                ],

                const Spacer(),

                // Share, More, Close
                if (!isMobile) ...[
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      foregroundColor: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                    ),
                    icon: const FaIcon(FontAwesomeIcons.shareNodes, size: 12),
                    label: const Text('Share', style: TextStyle(fontSize: 12)),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.ellipsis, size: 13),
                    tooltip: 'More',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                ],
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.xmark, size: 15),
                  tooltip: AppStrings.close.tr(),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  onPressed: onClose,
                ),
              ],
            ),
          ),

          // ─── Main Content Body ──────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                // Top Task Sub-Pill & Task ID Badge
                Row(
                  children: [
                    TaskIdBadge(
                      formattedId: task.displayId,
                      isLarge: true,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? OnyxColors.neutral800 : OnyxColors.neutral100,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isDark ? OnyxColors.neutral700 : OnyxColors.neutral300,
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(FontAwesomeIcons.circleDot, size: 11, color: OnyxColors.neutral400),
                          const SizedBox(width: 6),
                          Text(
                            task.taskType.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const FaIcon(FontAwesomeIcons.chevronDown, size: 9, color: OnyxColors.neutral400),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    FaIcon(
                      FontAwesomeIcons.expand,
                      size: 13,
                      color: isDark ? OnyxColors.neutral500 : OnyxColors.neutral400,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Bold Task Title
                isEditingTitle.value
                    ? TextField(
                        controller: titleController,
                        autofocus: true,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                        ),
                        decoration: const InputDecoration(border: InputBorder.none),
                        onSubmitted: (newTitle) {
                          isEditingTitle.value = false;
                          if (newTitle.trim().isNotEmpty && newTitle != task.title) {
                            tasksCubit.updateTask(task.copyWith(title: newTitle.trim()));
                          }
                        },
                      )
                    : InkWell(
                        onTap: () => isEditingTitle.value = true,
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                            color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                          ),
                        ),
                      ),
                const SizedBox(height: 16),

                // Sequential Role Pipeline & Execution Card
                RolePipelineCard(
                  task: task,
                  currentUser: currentUser,
                  isDark: isDark,
                  onUpdateSubStatus: (subStatus) {
                    tasksCubit.updateRoleSubStatus(
                      taskId: task.id,
                      subStatus: subStatus,
                      authorName: currentUser.name,
                    );
                  },
                  onManualStageChange: (newStage) {
                    tasksCubit.updateTask(task.copyWith(
                      currentRoleStage: newStage,
                      roleSubStatus: 'todo',
                    ));
                  },
                ),

                // ─── 2-Column ClickUp Properties Grid ────────────────────────
                _buildPropertyRow(
                  label: 'Status',
                  icon: FontAwesomeIcons.circleDot,
                  isDark: isDark,
                  valueWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PopupMenuButton<TaskStatus>(
                        tooltip: 'Change Status',
                        onSelected: (newStatus) {
                          tasksCubit.updateTaskStatus(
                            taskId: task.id,
                            newStatus: newStatus,
                            authorName: 'User',
                          );
                        },
                        itemBuilder: (ctx) => TaskStatus.values.map((s) {
                          return PopupMenuItem(
                            value: s,
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(color: s.color, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 8),
                                Text(s.label, style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          );
                        }).toList(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: task.status.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                task.status.label.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const FaIcon(FontAwesomeIcons.caretRight, size: 10, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Checkmark button (Mark as Closed)
                      InkWell(
                        onTap: () {
                          tasksCubit.updateTaskStatus(
                            taskId: task.id,
                            newStatus: TaskStatus.closed,
                            authorName: 'User',
                          );
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isDark ? OnyxColors.neutral800 : OnyxColors.neutral200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.check,
                              size: 11,
                              color: task.status == TaskStatus.closed ? OnyxColors.success : OnyxColors.neutral500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                _buildPropertyRow(
                  label: 'Assignees',
                  icon: FontAwesomeIcons.user,
                  isDark: isDark,
                  valueWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AssigneeAvatarBadge(name: devName, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        devName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                _buildPropertyRow(
                  label: 'Dates',
                  icon: FontAwesomeIcons.calendar,
                  isDark: isDark,
                  valueWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(FontAwesomeIcons.calendar, size: 11, color: OnyxColors.neutral400),
                      const SizedBox(width: 6),
                      Text(
                        'Start',
                        style: TextStyle(fontSize: 12, color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500),
                      ),
                      const SizedBox(width: 8),
                      const FaIcon(FontAwesomeIcons.arrowRight, size: 9, color: OnyxColors.neutral400),
                      const SizedBox(width: 8),
                      const FaIcon(FontAwesomeIcons.calendar, size: 11, color: OnyxColors.neutral400),
                      const SizedBox(width: 6),
                      Text(
                        hasDueDate ? DateFormat('M/d/yy').format(task.dueDate!) : 'Due',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: hasDueDate ? FontWeight.bold : FontWeight.normal,
                          color: hasDueDate
                              ? OnyxColors.danger
                              : (isDark ? OnyxColors.neutral400 : OnyxColors.neutral500),
                        ),
                      ),
                    ],
                  ),
                ),

                _buildPropertyRow(
                  label: 'Priority',
                  icon: FontAwesomeIcons.flag,
                  isDark: isDark,
                  valueWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.solidFlag,
                        size: 12,
                        color: task.priority.color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        task.priority.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: task.priority.color,
                        ),
                      ),
                    ],
                  ),
                ),

                _buildPropertyRow(
                  label: 'Time estimate',
                  icon: FontAwesomeIcons.hourglassHalf,
                  isDark: isDark,
                  valueWidget: Text(
                    task.estimatedHours > 0 ? '${task.estimatedHours}h' : 'Empty',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
                    ),
                  ),
                ),

                _buildPropertyRow(
                  label: 'Sprint points',
                  icon: FontAwesomeIcons.gear,
                  isDark: isDark,
                  valueWidget: Text(
                    'Empty',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                    ),
                  ),
                ),

                _buildPropertyRow(
                  label: 'Track time',
                  icon: FontAwesomeIcons.stopwatch,
                  isDark: isDark,
                  valueWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(FontAwesomeIcons.circlePlay, size: 13, color: OnyxColors.neutral400),
                      const SizedBox(width: 6),
                      Text(
                        'Start',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
                        ),
                      ),
                    ],
                  ),
                ),

                _buildPropertyRow(
                  label: 'Tags',
                  icon: FontAwesomeIcons.tag,
                  isDark: isDark,
                  valueWidget: Text(
                    'Empty',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // ─── Embedded Screen Mockup Preview Container ─────────────────
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? OnyxColors.darkSidebar : OnyxColors.neutral50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: isPreviewExpanded.value ? 400 : 160,
                          width: double.infinity,
                          color: isDark ? OnyxColors.neutral900 : OnyxColors.neutral200,
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.tableList,
                                      size: 36,
                                      color: isDark ? OnyxColors.neutral700 : OnyxColors.neutral400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${task.moduleCode} - ${task.screenName.isNotEmpty ? task.screenName : "Screen Preview"}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? OnyxColors.neutral500 : OnyxColors.neutral600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => isPreviewExpanded.value = !isPreviewExpanded.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                isPreviewExpanded.value ? FontAwesomeIcons.chevronUp : FontAwesomeIcons.chevronDown,
                                size: 10,
                                color: OnyxColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isPreviewExpanded.value ? 'Collapse' : 'Expand',
                                style: const TextStyle(
                                  fontSize: 12,
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

                const SizedBox(height: 16),

                // ─── Subtasks Section ─────────────────────────────────────────
                TaskSubtasksSection(
                  task: task,
                  isDark: isDark,
                  authorName: currentUser.name.isNotEmpty ? currentUser.name : 'User',
                ),

                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 16),

                // ─── Audit History Section ────────────────────────────────────
                Text(
                  AppStrings.activityHistory.tr(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                if (task.history.isEmpty)
                  Text(
                    AppStrings.noHistoryYet.tr(),
                    style: TextStyle(fontSize: 12, color: isDark ? OnyxColors.neutral500 : OnyxColors.neutral400),
                  )
                else
                  ...task.history.reversed.map((h) => TaskHistoryTile(item: h)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyRow({
    required String label,
    required FaIconData icon,
    required Widget valueWidget,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Row(
              children: [
                FaIcon(icon, size: 12, color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: valueWidget),
        ],
      ),
    );
  }
}
