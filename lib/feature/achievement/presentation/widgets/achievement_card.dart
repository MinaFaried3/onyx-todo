import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/achievement/domain/entities/daily_achievement_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';

class AchievementCard extends StatelessWidget {
  final DailyAchievementEntity item;
  final bool isDark;

  const AchievementCard({
    super.key,
    required this.item,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: ClickUpColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.developerStack.label,
                            style: const TextStyle(
                              fontSize: 10,
                              color: ClickUpColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      dateStr,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? ClickUpColors.neutral400 : ClickUpColors.neutral500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ClickUpColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${item.totalHours} ${AppStrings.workHoursUnit.tr()}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ClickUpColors.success,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.shareNodes, size: 16, color: ClickUpColors.teal),
                  tooltip: AppStrings.copyWhatsappSummary.tr(),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: item.toWhatsAppSummary()));
                    context.safeShowSnackBar(SnackBar(content: Text(AppStrings.whatsappSummaryCopied.tr())));
                  },
                ),
              ],
            ),
            Divider(
              height: 20,
              color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
            ),

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
                        color: isDark ? ClickUpColors.neutral700 : ClickUpColors.neutral200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        t.moduleCode,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isDark ? ClickUpColors.neutral300 : ClickUpColors.neutral700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t.title,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '${t.hoursSpent}h',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
                      ),
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
                  color: ClickUpColors.danger.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: ClickUpColors.danger.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.circleExclamation, size: 14, color: ClickUpColors.danger),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${AppStrings.blockers.tr()}: ${item.blockers}',
                        style: const TextStyle(fontSize: 11, color: ClickUpColors.danger),
                      ),
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
                  color: ClickUpColors.info.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: ClickUpColors.info.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.arrowTrendUp, size: 14, color: ClickUpColors.info),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${AppStrings.nextDayPlan.tr()}: ${item.nextDayPlan}',
                        style: const TextStyle(fontSize: 11, color: ClickUpColors.info),
                      ),
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
}
