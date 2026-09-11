import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/notification/presentation/widgets/notification_dropdown_overlay.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_create_dialog.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';
import 'package:onyx_todo/feature/workspace/presentation/widgets/module_hierarchy_dialog.dart';
import 'package:onyx_todo/feature/workspace/presentation/widgets/onyx_view_tab.dart';

class OnyxTopBar extends StatelessWidget {
  const OnyxTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceCubit = context.workspaceCubit;
    final state = workspaceCubit.state;
    final activeView = state.activeView;
    final isTaskView = activeView == WorkspaceView.list ||
        activeView == WorkspaceView.board ||
        activeView == WorkspaceView.workload ||
        activeView == WorkspaceView.analytics;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? OnyxColors.darkSidebar : OnyxColors.lightSidebar,
        border: Border(
          bottom: BorderSide(
            color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Breadcrumb / Active Space Title
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.solidFolder, size: 14, color: OnyxColors.primary),
              const SizedBox(width: 8),
              Text(
                '${AppStrings.appName.tr()} / ',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                ),
              ),
              Text(
                state.selectedModuleCode == 'ALL'
                    ? AppStrings.allModules.tr()
                    : state.selectedModuleCode,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                ),
              ),
              if (state.selectedModuleCode != 'ALL') ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => BlocProvider.value(
                        value: workspaceCubit,
                        child: ModuleHierarchyDialog(moduleCode: state.selectedModuleCode),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: OnyxColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.sitemap,
                          size: 11,
                          color: isDark ? OnyxColors.primaryLight : OnyxColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppStrings.moduleHierarchy.tr(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? OnyxColors.primaryLight : OnyxColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(width: 24),

          // View Tabs (List, Board, Workload, Analytics) when in Tasks view
          if (isTaskView) ...[
            OnyxViewTab(
              icon: FontAwesomeIcons.listCheck,
              label: AppStrings.listView.tr(),
              isSelected: activeView == WorkspaceView.list,
              onTap: () => workspaceCubit.setView(WorkspaceView.list),
              isDark: isDark,
            ),
            const SizedBox(width: 4),
            OnyxViewTab(
              icon: FontAwesomeIcons.tableColumns,
              label: AppStrings.boardView.tr(),
              isSelected: activeView == WorkspaceView.board,
              onTap: () => workspaceCubit.setView(WorkspaceView.board),
              isDark: isDark,
            ),
            const SizedBox(width: 4),
            OnyxViewTab(
              icon: FontAwesomeIcons.chartLine,
              label: AppStrings.workloadView.tr(),
              isSelected: activeView == WorkspaceView.workload,
              onTap: () => workspaceCubit.setView(WorkspaceView.workload),
              isDark: isDark,
            ),
            const SizedBox(width: 4),
            OnyxViewTab(
              icon: FontAwesomeIcons.chartPie,
              label: AppStrings.analyticsView.tr(),
              isSelected: activeView == WorkspaceView.analytics,
              onTap: () => workspaceCubit.setView(WorkspaceView.analytics),
              isDark: isDark,
            ),
          ],

          const Spacer(),

          // Notification Bell
          IconButton(
            tooltip: AppStrings.notifications.tr(),
            icon: Badge(
              isLabelVisible: state.unreadNotificationCount > 0,
              label: Text(
                '${state.unreadNotificationCount}',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              backgroundColor: OnyxColors.danger,
              child: FaIcon(
                FontAwesomeIcons.solidBell,
                size: 16,
                color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierColor: Colors.transparent,
                builder: (ctx) => BlocProvider.value(
                  value: workspaceCubit,
                  child: const NotificationDropdownOverlay(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),

          // Quick Language Switcher
          TextButton.icon(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              foregroundColor: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
            ),
            icon: const FaIcon(FontAwesomeIcons.globe, size: 13),
            label: Text(
              context.locale.languageCode == 'ar' ? 'English' : 'العربية',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              if (context.locale.languageCode == 'ar') {
                context.setLocale(const Locale('en', 'US'));
              } else {
                context.setLocale(const Locale('ar', 'EG'));
              }
            },
          ),
          const SizedBox(width: 4),

          // Dark / Light Mode Switcher
          IconButton(
            tooltip: isDark ? 'الوضع الفاتح / Light Mode' : 'الوضع الداكن / Dark Mode',
            icon: FaIcon(
              isDark ? FontAwesomeIcons.solidSun : FontAwesomeIcons.solidMoon,
              size: 15,
              color: isDark ? OnyxColors.warning : OnyxColors.neutral700,
            ),
            onPressed: () => workspaceCubit.toggleThemeMode(),
          ),
          const SizedBox(width: 8),

          // New Task Action Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: OnyxColors.primary,
              foregroundColor: OnyxColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            icon: const FaIcon(FontAwesomeIcons.plus, size: 12),
            label: Text(
              AppStrings.createTask.tr(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              final tasksCubit = context.tasksCubit;
              showDialog(
                context: context,
                builder: (ctx) => BlocProvider.value(
                  value: tasksCubit,
                  child: TaskCreateDialog(
                    defaultVersion: state.selectedVersionCode,
                    defaultModuleCode: state.selectedModuleCode,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
