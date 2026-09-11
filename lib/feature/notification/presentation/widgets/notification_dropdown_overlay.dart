import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';

class NotificationDropdownOverlay extends StatelessWidget {
  const NotificationDropdownOverlay({super.key});

  FaIconData _getIcon(NotificationType type) {
    return switch (type) {
      NotificationType.taskAssigned => FontAwesomeIcons.userCheck,
      NotificationType.statusChanged => FontAwesomeIcons.arrowsRotate,
      NotificationType.systemAnnouncement => FontAwesomeIcons.bullhorn,
    };
  }

  Color _getColor(NotificationType type) {
    return switch (type) {
      NotificationType.taskAssigned => OnyxColors.info,
      NotificationType.statusChanged => OnyxColors.success,
      NotificationType.systemAnnouncement => OnyxColors.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final workspaceCubit = context.workspaceCubit;
    final state = workspaceCubit.state;
    final notifications = state.notificationsState.data ?? [];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      alignment: Alignment.topRight,
      insetPadding: const EdgeInsets.only(top: 60, right: 20, left: 20),
      backgroundColor: isDark ? OnyxColors.darkCard : OnyxColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 520),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.bell, size: 14, color: OnyxColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.notifications.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (notifications.any((n) => !n.isRead))
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => workspaceCubit.markAllNotificationsAsRead(),
                      child: Text(
                        AppStrings.markAllRead.tr(),
                        style: const TextStyle(fontSize: 11, color: OnyxColors.primary),
                      ),
                    ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.xmark, size: 13),
                    onPressed: () => context.safePop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Notification list
            Expanded(
              child: notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.bellSlash,
                            size: 32,
                            color: isDark ? OnyxColors.neutral600 : OnyxColors.neutral400,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppStrings.noNotifications.tr(),
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: notifications.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final notif = notifications[index];
                        final color = _getColor(notif.type);

                        return InkWell(
                          onTap: () {
                            workspaceCubit.markNotificationAsRead(notif.id);
                            if (notif.taskId != null) {
                              final tasksCubit = context.tasksCubit;
                              final tasks = tasksCubit.state.tasksState.data ?? [];
                              final match = tasks.where((t) => t.id == notif.taskId || t.formattedId == notif.taskId).firstOrNull;
                              if (match != null) {
                                tasksCubit.selectTask(match);
                              }
                              context.safePop();
                            }
                          },
                          child: Container(
                            color: notif.isRead
                                ? Colors.transparent
                                : OnyxColors.primary.withValues(alpha: isDark ? 0.08 : 0.05),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: color.withValues(alpha: 0.15),
                                  child: FaIcon(_getIcon(notif.type), size: 12, color: color),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              notif.title,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.bold,
                                                color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (!notif.isRead)
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                color: OnyxColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        notif.message,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
