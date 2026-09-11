import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_create_dialog.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';

class ClickUpTopBar extends StatelessWidget {
  const ClickUpTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceCubit = context.workspaceCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      builder: (context, state) {
        final activeView = state.activeView;
        final selectedModule = state.selectedModuleCode;
        final selectedVersion = state.selectedVersionCode;

        final isTaskView = activeView == WorkspaceView.list ||
            activeView == WorkspaceView.board ||
            activeView == WorkspaceView.workload ||
            activeView == WorkspaceView.analytics;

        return Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
            border: Border(
              bottom: BorderSide(
                color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
              ),
            ),
          ),
          child: Row(
            children: [
              // Breadcrumb
              const FaIcon(FontAwesomeIcons.house, size: 13, color: ClickUpColors.neutral400),
              const SizedBox(width: 8),
              Text(
                AppStrings.onyxErp.tr(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 6),
              const FaIcon(FontAwesomeIcons.chevronRight, size: 10, color: ClickUpColors.neutral400),
              const SizedBox(width: 6),
              Text(
                selectedModule == 'ALL' ? AppStrings.all.tr() : selectedModule,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: ClickUpColors.primary,
                ),
              ),
              const SizedBox(width: 6),
              const FaIcon(FontAwesomeIcons.chevronRight, size: 10, color: ClickUpColors.neutral400),
              const SizedBox(width: 6),
              Text(
                selectedVersion,
                style: const TextStyle(fontSize: 12, color: ClickUpColors.neutral400),
              ),

              const SizedBox(width: 24),

              // View Tabs (List, Board, Workload, Analytics) when in Tasks view
              if (isTaskView) ...[
                _buildViewTab(
                  icon: FontAwesomeIcons.listCheck,
                  label: AppStrings.listView.tr(),
                  isSelected: activeView == WorkspaceView.list,
                  onTap: () => workspaceCubit.setView(WorkspaceView.list),
                  isDark: isDark,
                ),
                const SizedBox(width: 4),
                _buildViewTab(
                  icon: FontAwesomeIcons.tableColumns,
                  label: AppStrings.boardView.tr(),
                  isSelected: activeView == WorkspaceView.board,
                  onTap: () => workspaceCubit.setView(WorkspaceView.board),
                  isDark: isDark,
                ),
                const SizedBox(width: 4),
                _buildViewTab(
                  icon: FontAwesomeIcons.chartLine,
                  label: AppStrings.workloadView.tr(),
                  isSelected: activeView == WorkspaceView.workload,
                  onTap: () => workspaceCubit.setView(WorkspaceView.workload),
                  isDark: isDark,
                ),
                const SizedBox(width: 4),
                _buildViewTab(
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
                icon: const FaIcon(FontAwesomeIcons.globe, size: 13),
                label: Text(
                  context.locale.languageCode == 'ar' ? 'English' : 'العربية',
                  style: const TextStyle(fontSize: 12),
                ),
                onPressed: () {
                  final newLocale = context.locale.languageCode == 'ar'
                      ? const Locale('en', 'US')
                      : const Locale('ar', 'EG');
                  context.setLocale(newLocale);
                },
              ),
              const SizedBox(width: 8),

              // Quick + Task Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ClickUpColors.primary,
                  foregroundColor: ClickUpColors.white,
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
                      defaultVersion: selectedVersion,
                      defaultModuleCode: selectedModule,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildViewTab({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? ClickUpColors.primary.withValues(alpha: 0.12)
              : ClickUpColors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border.all(color: ClickUpColors.primary.withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          children: [
            FaIcon(
              icon,
              size: 13,
              color: isSelected ? ClickUpColors.primary : ClickUpColors.neutral400,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? ClickUpColors.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
