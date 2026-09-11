import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/auth/domain/entities/user_profile.dart';
import 'package:onyx_todo/feature/auth/presentation/widgets/user_password_reset_dialog.dart';
import 'package:onyx_todo/feature/task/presentation/cubit/tasks_cubit.dart';
import 'package:onyx_todo/feature/task/presentation/cubit/tasks_state.dart';
import 'package:onyx_todo/feature/team/domain/entities/team_entity.dart';
import 'package:onyx_todo/feature/team/presentation/widgets/team_create_dialog.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';

class TeamManagementScreen extends HookWidget {
  const TeamManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeTab = useState<int>(0); // 0: Teams & Reports, 1: Users Directory
    final userSearchQuery = useState<String>('');
    final selectedRoleFilter = useState<UserRole?>(null);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      builder: (context, state) {
        final teams = state.teamsState.data ?? [];
        final users = state.usersState.data ?? [];

        return Scaffold(
          backgroundColor: isDark ? OnyxColors.darkBackground : OnyxColors.lightBackground,
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header with Tabs
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.usersGear, color: OnyxColors.primary, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      AppStrings.teamsAndUsers.tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(width: 24),

                    // Tab Switcher
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? OnyxColors.darkCard : OnyxColors.neutral200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.peopleGroup, size: 12),
                                const SizedBox(width: 6),
                                Text(AppStrings.teams.tr()),
                              ],
                            ),
                            selected: activeTab.value == 0,
                            selectedColor: OnyxColors.primary,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: activeTab.value == 0 ? OnyxColors.white : OnyxColors.neutral400,
                            ),
                            onSelected: (_) => activeTab.value = 0,
                          ),
                          const SizedBox(width: 4),
                          ChoiceChip(
                            label: Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.users, size: 12),
                                const SizedBox(width: 6),
                                Text(AppStrings.users.tr()),
                              ],
                            ),
                            selected: activeTab.value == 1,
                            selectedColor: OnyxColors.primary,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: activeTab.value == 1 ? OnyxColors.white : OnyxColors.neutral400,
                            ),
                            onSelected: (_) => activeTab.value = 1,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    if (activeTab.value == 0)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: OnyxColors.primary,
                          foregroundColor: OnyxColors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.plus, size: 12),
                        label: Text(
                          AppStrings.addTeam.tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => const TeamCreateDialog(),
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tab Content
                Expanded(
                  child: activeTab.value == 0
                      ? _buildTeamsView(context, teams, users, isDark)
                      : _buildUsersView(
                          context,
                          users,
                          teams,
                          userSearchQuery,
                          selectedRoleFilter,
                          isDark,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeamsView(
    BuildContext context,
    List<TeamEntity> teams,
    List<UserProfile> users,
    bool isDark,
  ) {
    if (teams.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noTeamsFound.tr(),
          style: const TextStyle(color: OnyxColors.neutral400),
        ),
      );
    }

    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, tasksState) {
        final allTasks = tasksState.tasksState.data ?? [];

        return ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            final teamMembers = users.where((u) => team.memberIds.contains(u.id) || u.teamId == team.id).toList();
            final teamTasks = allTasks.where((t) => team.moduleCodes.contains(t.moduleCode)).toList();

            final completedCount = teamTasks.where((t) => t.status == TaskStatus.closed).length;
            final inProgressCount = teamTasks.where((t) => t.status == TaskStatus.inProgress).length;
            final solvedCount = teamTasks.where((t) => t.status == TaskStatus.backendSolved || t.status == TaskStatus.frontendSolved).length;
            final totalHours = teamTasks.fold<double>(0.0, (sum, t) => sum + (t.actualHours > 0 ? t.actualHours : t.estimatedHours));
            final completionRate = teamTasks.isEmpty ? 0 : ((completedCount / teamTasks.length) * 100).toInt();

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
                ),
              ),
              color: isDark ? OnyxColors.darkCard : OnyxColors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Team Title & Actions
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: OnyxColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const FaIcon(FontAwesomeIcons.peopleGroup, color: OnyxColors.primary, size: 16),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                team.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                                ),
                              ),
                              if (team.description != null && team.description!.isNotEmpty)
                                Text(
                                  team.description!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 14),
                          tooltip: AppStrings.editTeam.tr(),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => TeamCreateDialog(initialTeam: team),
                            );
                          },
                        ),
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.trashCan, size: 14, color: OnyxColors.danger),
                          tooltip: AppStrings.deleteTeam.tr(),
                          onPressed: () => context.workspaceCubit.deleteTeam(team.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Team Lead & Assigned Modules
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (team.leaderName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: OnyxColors.warning.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FaIcon(FontAwesomeIcons.crown, size: 11, color: OnyxColors.warning),
                                const SizedBox(width: 6),
                                Text(
                                  '${AppStrings.teamLead.tr()}: ${team.leaderName}',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: OnyxColors.warning),
                                ),
                              ],
                            ),
                          ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${AppStrings.assignModules.tr()}: ',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
                              ),
                            ),
                            Wrap(
                              spacing: 4,
                              children: team.moduleCodes.map((code) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: OnyxColors.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    code,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: OnyxColors.primary),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    // Team Statistics & KPI Row
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? OnyxColors.darkBackground : OnyxColors.neutral100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn(AppStrings.totalTasksMetric.tr(), '${teamTasks.length}', OnyxColors.primary),
                          _buildStatColumn(AppStrings.statusInProgress.tr(), '$inProgressCount', OnyxColors.info),
                          _buildStatColumn(AppStrings.statusBackendSolved.tr(), '$solvedCount', OnyxColors.purple),
                          _buildStatColumn(AppStrings.statusClosed.tr(), '$completedCount', OnyxColors.success),
                          _buildStatColumn(AppStrings.completionRateMetric.tr(), '$completionRate%', OnyxColors.teal),
                          _buildStatColumn(AppStrings.totalLoggedHours.tr(), '${totalHours.toStringAsFixed(0)}h', OnyxColors.warning),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Members Chips
                    Text(
                      '${AppStrings.teamMembers.tr()} (${teamMembers.length}):',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: teamMembers.map((m) {
                        return Chip(
                          avatar: CircleAvatar(
                            backgroundColor: OnyxColors.primary,
                            child: Text(
                              m.name.substring(0, 1),
                              style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          label: Text('${m.name} (${m.role.label})', style: const TextStyle(fontSize: 11)),
                          backgroundColor: isDark ? OnyxColors.darkCard : OnyxColors.neutral200,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: OnyxColors.neutral400),
        ),
      ],
    );
  }

  Widget _buildUsersView(
    BuildContext context,
    List<UserProfile> users,
    List<TeamEntity> teams,
    ValueNotifier<String> searchQuery,
    ValueNotifier<UserRole?> roleFilter,
    bool isDark,
  ) {
    final workspaceCubit = context.workspaceCubit;

    final filteredUsers = users.where((u) {
      final matchesSearch = u.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          u.email.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchesRole = roleFilter.value == null || u.role == roleFilter.value;
      return matchesSearch && matchesRole;
    }).toList();

    return Column(
      children: [
        // Search and Role Filter Bar
        Row(
          children: [
            SizedBox(
              width: 260,
              height: 38,
              child: TextField(
                onChanged: (v) => searchQuery.value = v,
                decoration: InputDecoration(
                  hintText: '${AppStrings.search.tr()} بالاسم أو البريد...',
                  prefixIcon: const Center(
                    widthFactor: 1.0,
                    child: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 12, color: OnyxColors.neutral400),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            DropdownButton<UserRole?>(
              value: roleFilter.value,
              hint: Text(AppStrings.userRole.tr(), style: const TextStyle(fontSize: 12)),
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(value: null, child: Text(AppStrings.all.tr(), style: const TextStyle(fontSize: 12))),
                ...UserRole.values.map((r) => DropdownMenuItem(value: r, child: Text(r.label, style: const TextStyle(fontSize: 12)))),
              ],
              onChanged: (r) => roleFilter.value = r,
            ),
            const Spacer(),
            Text(
              '${AppStrings.allUsers.tr()}: ${filteredUsers.length}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Users List Table
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder),
            ),
            color: isDark ? OnyxColors.darkCard : OnyxColors.white,
            child: ListView.separated(
              itemCount: filteredUsers.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final u = filteredUsers[index];
                final team = teams.where((t) => t.id == u.teamId || t.memberIds.contains(u.id)).firstOrNull;
                final isCurrent = u.id == workspaceCubit.state.currentUser.id;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: OnyxColors.primary.withValues(alpha: 0.2),
                        child: Text(
                          u.name.substring(0, 1),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: OnyxColors.primary),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Name & Email
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  u.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                                  ),
                                ),
                                if (isCurrent) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: OnyxColors.success.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      AppStrings.activeNow.tr(),
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: OnyxColors.success),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              u.email,
                              style: const TextStyle(fontSize: 11, color: OnyxColors.neutral400),
                            ),
                          ],
                        ),
                      ),

                      // Role Chip
                      Expanded(
                        flex: 2,
                        child: PopupMenuButton<UserRole>(
                          tooltip: AppStrings.changeRole.tr(),
                          onSelected: (role) => workspaceCubit.updateUserRole(u.id, role),
                          itemBuilder: (_) => UserRole.values.map((r) {
                            return PopupMenuItem(value: r, child: Text(r.label));
                          }).toList(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: OnyxColors.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  u.role.label,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: OnyxColors.primary),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const FaIcon(FontAwesomeIcons.caretDown, size: 9, color: OnyxColors.neutral400),
                            ],
                          ),
                        ),
                      ),

                      // Assigned Team
                      Expanded(
                        flex: 2,
                        child: PopupMenuButton<String>(
                          tooltip: AppStrings.assignToTeam.tr(),
                          onSelected: (tId) => workspaceCubit.assignUserToTeam(u.id, tId),
                          itemBuilder: (_) => teams.map((t) {
                            return PopupMenuItem(value: t.id, child: Text(t.name));
                          }).toList(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  team?.name ?? AppStrings.unassigned.tr(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: team != null ? OnyxColors.info : OnyxColors.neutral400,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const FaIcon(FontAwesomeIcons.caretDown, size: 9, color: OnyxColors.neutral400),
                            ],
                          ),
                        ),
                      ),

                      // Last Active Timestamp
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${AppStrings.lastActive.tr()}: ${DateFormat('yyyy/MM/dd HH:mm').format(u.lastActiveAt)}',
                          style: const TextStyle(fontSize: 10, color: OnyxColors.neutral400),
                        ),
                      ),

                      // Action Buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const FaIcon(FontAwesomeIcons.key, size: 12),
                            tooltip: AppStrings.resetPassword.tr(),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => UserPasswordResetDialog(initialEmail: u.email),
                              );
                            },
                          ),
                          if (!isCurrent)
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.rightToBracket, size: 12, color: OnyxColors.primary),
                              tooltip: AppStrings.switchAccount.tr(),
                              onPressed: () => workspaceCubit.switchUser(u.id),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
