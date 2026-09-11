import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';

class OnyxCollapsedSidebar extends StatelessWidget {
  const OnyxCollapsedSidebar({
    required this.cubit,
    required this.isDark,
    super.key,
  });

  final WorkspaceCubit cubit;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      color: isDark ? OnyxColors.darkSidebar : OnyxColors.lightSidebar,
      child: Column(
        children: [
          const SizedBox(height: 16),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.anglesRight, size: 14),
            tooltip: AppStrings.expandMenu.tr(),
            onPressed: () => cubit.toggleSidebar(),
          ),
          const SizedBox(height: 16),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.listCheck, size: 15),
            tooltip: AppStrings.tasks.tr(),
            onPressed: () => cubit.setView(WorkspaceView.list),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.chartPie, size: 15),
            tooltip: AppStrings.analyticsView.tr(),
            onPressed: () => cubit.setView(WorkspaceView.analytics),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.trophy, size: 15),
            tooltip: AppStrings.dailyAchievements.tr(),
            onPressed: () => cubit.setView(WorkspaceView.achievements),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.calendarCheck, size: 15),
            tooltip: AppStrings.monthlyPlan.tr(),
            onPressed: () => cubit.setView(WorkspaceView.monthlyPlan),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.usersGear, size: 15),
            tooltip: AppStrings.teamsAndUsers.tr(),
            onPressed: () => cubit.setView(WorkspaceView.teamManagement),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.fileExcel, size: 15),
            tooltip: AppStrings.excelImport.tr(),
            onPressed: () => cubit.setView(WorkspaceView.excelImport),
          ),
        ],
      ),
    );
  }
}
