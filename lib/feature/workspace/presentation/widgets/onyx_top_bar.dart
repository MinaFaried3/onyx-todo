import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_create_dialog.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';
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
              showDialog(
                context: context,
                builder: (ctx) => TaskCreateDialog(
                  defaultVersion: state.selectedVersion,
                  defaultModuleCode: state.selectedModuleCode,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
