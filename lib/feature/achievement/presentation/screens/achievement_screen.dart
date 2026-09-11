import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/achievement/domain/entities/daily_achievement_entity.dart';
import 'package:onyx_todo/feature/achievement/presentation/cubit/achievement_cubit.dart';
import 'package:onyx_todo/feature/achievement/presentation/cubit/achievement_state.dart';
import 'package:onyx_todo/feature/achievement/presentation/widgets/log_achievement_dialog.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_cubit.dart';

class AchievementScreen extends HookWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievementCubit = context.achievementCubit;
    final workspaceCubit = context.workspaceCubit;
    final currentUser = workspaceCubit.state.currentUser;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
    ];

    return BlocBuilder<AchievementCubit, AchievementState>(
      builder: (context, state) {
        final achievements = state.achievementsState.data ?? [];
        final totalHours = state.totalLoggedHours;
        final totalTasks = achievements.fold<int>(
          0,
          (sum, a) => sum + a.tasksWorked.length,
        );

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
                    const Icon(Icons.insights_rounded, color: ClickUpColors.primary, size: 28),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.dailyAchievements.tr(),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'متابعة إنجاز الفريق يومياً وأسبوعياً وشهرياً (بديل رسائل الواتساب)',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Log Daily Achievement Button (for Developers)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      icon: const Icon(Icons.playlist_add_check_circle_rounded, size: 18),
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

                // Period Filter Pills + Developer Filter
                Row(
                  children: [
                    ...filters.map((f) {
                      final isSelected = state.selectedFilter == f['key'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(f['label']!),
                          selected: isSelected,
                          selectedColor: ClickUpColors.primary.withValues(alpha: 0.2),
                          onSelected: (_) => achievementCubit.setFilter(f['key']!),
                        ),
                      );
                    }),
                    const Spacer(),

                    // If Department Manager, can filter by developer
                    if (currentUser.isDepartmentManager) ...[
                      const Text('تصفية حسب المطور: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      DropdownButton<String?>(
                        value: state.developerFilter,
                        hint: const Text('كافة المطورين', style: TextStyle(fontSize: 12)),
                        underline: const SizedBox(),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('كافة المطورين', style: TextStyle(fontSize: 12))),
                          ...workspaceCubit.state.availableUsers.map((u) {
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
                    _buildKpiCard(
                      AppStrings.totalLoggedHours.tr(),
                      '${totalHours.toStringAsFixed(1)}h',
                      'إجمالي ساعات العمل المسجلة',
                      Icons.schedule_rounded,
                      Colors.blue,
                      isDark,
                    ),
                    const SizedBox(width: 14),
                    _buildKpiCard(
                      'المهام المنجزة',
                      '$totalTasks',
                      'في الفترة المحددة',
                      Icons.task_alt_rounded,
                      Colors.green,
                      isDark,
                    ),
                    const SizedBox(width: 14),
                    _buildKpiCard(
                      'المطورون النشطون',
                      '${achievements.map((a) => a.developerName).toSet().length}',
                      'قاموا بتسجيل إنجازاتهم',
                      Icons.groups_rounded,
                      Colors.purple,
                      isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Achievements List
                Expanded(
                  child: state.achievementsState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : achievements.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              itemCount: achievements.length,
                              itemBuilder: (context, index) {
                                final item = achievements[index];
                                return _buildAchievementCard(context, item, isDark);
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.feed_outlined, size: 54, color: Colors.grey.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          const Text(
            'لا توجد سجلات إنجاز في هذه الفترة',
            style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
    BuildContext context,
    DailyAchievementEntity item,
    bool isDark,
  ) {
    final dateStr = DateFormat('yyyy/MM/dd').format(item.date);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
        ),
      ),
      color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Dev Name + Stack + Date + Total Hours + WhatsApp Copy
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: ClickUpColors.primary.withValues(alpha: 0.2),
                  child: Text(
                    item.developerName.substring(0, item.developerName.length >= 2 ? 2 : 1).toUpperCase(),
                    style: const TextStyle(color: ClickUpColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.developerName,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.developerStack.label,
                            style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Text(dateStr, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${item.totalHours} ساعة عمل',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.share_rounded, size: 18, color: Colors.teal),
                  tooltip: AppStrings.copyWhatsappSummary.tr(),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: item.toWhatsAppSummary()));
                    context.safeShowSnackBar(AppStrings.whatsappSummaryCopied.tr());
                  },
                ),
              ],
            ),
            const Divider(height: 20),

            // Tasks List
            ...item.tasksWorked.map((t) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    TaskIdBadge(formattedId: t.formattedId),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.black12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(t.moduleCode, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(t.title, style: const TextStyle(fontSize: 13))),
                    Text(
                      '${t.hoursSpent}h',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              );
            }),

            // Blockers & Next Day Plan
            if (item.blockers != null && item.blockers!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('العوائق: ${item.blockers}', style: const TextStyle(fontSize: 11, color: Colors.red)),
                    ),
                  ],
                ),
              ),
            ],
            if (item.nextDayPlan != null && item.nextDayPlan!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up_rounded, size: 16, color: Colors.blue),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('خطة الغد: ${item.nextDayPlan}', style: const TextStyle(fontSize: 11, color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
