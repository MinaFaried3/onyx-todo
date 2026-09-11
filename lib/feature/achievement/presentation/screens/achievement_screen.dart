import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/achievement/presentation/cubit/achievement_cubit.dart';
import 'package:onyx_todo/feature/achievement/presentation/cubit/achievement_state.dart';
import 'package:onyx_todo/feature/achievement/presentation/widgets/achievement_card.dart';
import 'package:onyx_todo/feature/achievement/presentation/widgets/achievement_empty_state.dart';
import 'package:onyx_todo/feature/achievement/presentation/widgets/achievement_kpi_card.dart';
import 'package:onyx_todo/feature/achievement/presentation/widgets/log_achievement_dialog.dart';

class AchievementScreen extends HookWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievementCubit = context.achievementCubit;
    final workspaceCubit = context.workspaceCubit;
    final currentUser = workspaceCubit.state.currentUser;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedTeamId = useState<String?>(null);

    useEffect(() {
      achievementCubit.fetchAchievements(
        developerName: currentUser.isDepartmentManager ? null : currentUser.name,
      );
      return null;
    }, [currentUser.id]);

    final filters = [
      {'key': 'today', 'label': AppStrings.filterToday.tr()},
      {'key': 'yesterday', 'label': AppStrings.filterYesterday.tr()},
      {'key': 'this_week', 'label': AppStrings.filterThisWeek.tr()},
      {'key': 'last_week', 'label': AppStrings.filterLastWeek.tr()},
      {'key': 'this_month', 'label': AppStrings.filterThisMonth.tr()},
      {'key': 'custom', 'label': AppStrings.filterCustom.tr()},
    ];

    return BlocBuilder<AchievementCubit, AchievementState>(
      builder: (context, state) {
        final allAchievements = state.achievementsState.data ?? [];
        final teams = workspaceCubit.state.teamsState.data ?? [];

        // Filter achievements by team if selected
        final achievements = selectedTeamId.value == null
            ? allAchievements
            : allAchievements.where((a) {
                final team = teams.where((t) => t.id == selectedTeamId.value).firstOrNull;
                if (team == null) return true;
                final dev = workspaceCubit.state.availableUsers.where((u) => u.name == a.developerName).firstOrNull;
                return dev != null && team.memberIds.contains(dev.id);
              }).toList();

        final totalHours = achievements.fold<double>(0.0, (sum, a) => sum + a.totalHours);
        final totalTasks = achievements.fold<int>(
          0,
          (sum, a) => sum + a.tasksWorked.length,
        );

        final availableDevs = selectedTeamId.value == null
            ? workspaceCubit.state.availableUsers
            : workspaceCubit.state.availableUsers.where((u) {
                final team = teams.where((t) => t.id == selectedTeamId.value).firstOrNull;
                return team != null && team.memberIds.contains(u.id);
              }).toList();

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Bar
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.chartLine, color: OnyxColors.primary, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.dailyAchievements.tr(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          AppStrings.teamAchievementSubtitle.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Log Daily Achievement Button (for Developers)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OnyxColors.success,
                        foregroundColor: OnyxColors.lightCard,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      icon: const FaIcon(FontAwesomeIcons.circleCheck, size: 14),
                      label: Text(
                        AppStrings.logDailyAchievement.tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => const LogAchievementDialog(),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Period Filter Pills + Team & Developer Filter
                Row(
                  children: [
                    ...filters.map((f) {
                      final isSelected = state.selectedFilter == f['key'];
                      String label = f['label']!;
                      if (f['key'] == 'custom' && state.customStartDate != null && state.customEndDate != null) {
                        label = '${DateFormat('MM/dd').format(state.customStartDate!)} - ${DateFormat('MM/dd').format(state.customEndDate!)}';
                      }

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          selectedColor: OnyxColors.primary.withValues(alpha: 0.2),
                          onSelected: (_) async {
                            if (f['key'] == 'custom') {
                              final picked = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                                initialDateRange: state.customStartDate != null && state.customEndDate != null
                                    ? DateTimeRange(start: state.customStartDate!, end: state.customEndDate!)
                                    : null,
                              );
                              if (picked != null) {
                                achievementCubit.setFilter('custom', customStart: picked.start, customEnd: picked.end);
                              }
                            } else {
                              achievementCubit.setFilter(f['key']!);
                            }
                          },
                        ),
                      );
                    }),
                    const Spacer(),

                    // If Department Manager, can filter by Team and Developer
                    if (currentUser.isDepartmentManager) ...[
                      // Team Filter Dropdown
                      Text(
                        '${AppStrings.assignedTeam.tr()}: ',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                        ),
                      ),
                      DropdownButton<String?>(
                        value: selectedTeamId.value,
                        hint: Text(
                          AppStrings.all.tr(),
                          style: const TextStyle(fontSize: 12),
                        ),
                        underline: const SizedBox(),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(AppStrings.all.tr(), style: const TextStyle(fontSize: 12)),
                          ),
                          ...teams.map((t) {
                            return DropdownMenuItem(
                              value: t.id,
                              child: Text(t.name, style: const TextStyle(fontSize: 12)),
                            );
                          }),
                        ],
                        onChanged: (tId) {
                          selectedTeamId.value = tId;
                          if (tId != null) {
                            final team = teams.where((t) => t.id == tId).firstOrNull;
                            if (team != null && state.developerFilter != null) {
                              final dev = workspaceCubit.state.availableUsers.where((u) => u.name == state.developerFilter).firstOrNull;
                              if (dev != null && !team.memberIds.contains(dev.id)) {
                                achievementCubit.setDeveloperFilter(null);
                              }
                            }
                          }
                        },
                      ),
                      const SizedBox(width: 14),

                      // Developer Filter Dropdown
                      Text(
                        '${AppStrings.filterByDeveloper.tr()}: ',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                        ),
                      ),
                      DropdownButton<String?>(
                        value: state.developerFilter,
                        hint: Text(
                          AppStrings.allDevelopers.tr(),
                          style: const TextStyle(fontSize: 12),
                        ),
                        underline: const SizedBox(),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(
                              AppStrings.allDevelopers.tr(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          ...availableDevs.map((u) {
                            return DropdownMenuItem(
                              value: u.name,
                              child: Text(u.name, style: const TextStyle(fontSize: 12)),
                            );
                          }),
                        ],
                        onChanged: (dev) => achievementCubit.setDeveloperFilter(dev),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Summary KPIs
                Row(
                  children: [
                    AchievementKpiCard(
                      title: AppStrings.totalLoggedHours.tr(),
                      value: '${totalHours.toStringAsFixed(1)}h',
                      subtitle: AppStrings.workHoursUnit.tr(),
                      icon: FontAwesomeIcons.clock,
                      color: OnyxColors.info,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 14),
                    AchievementKpiCard(
                      title: AppStrings.completedTasksMetric.tr(),
                      value: '$totalTasks',
                      subtitle: AppStrings.taskCountLabel.tr(),
                      icon: FontAwesomeIcons.circleCheck,
                      color: OnyxColors.success,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 14),
                    AchievementKpiCard(
                      title: AppStrings.activeDevelopers.tr(),
                      value: '${achievements.map((a) => a.developerName).toSet().length}',
                      subtitle: AppStrings.activeDevelopers.tr(),
                      icon: FontAwesomeIcons.users,
                      color: OnyxColors.purple,
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Achievements List
                Expanded(
                  child: state.achievementsState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : achievements.isEmpty
                          ? AchievementEmptyState(isDark: isDark)
                          : ListView.builder(
                              itemCount: achievements.length,
                              itemBuilder: (context, index) {
                                final item = achievements[index];
                                return AchievementCard(item: item, isDark: isDark);
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

