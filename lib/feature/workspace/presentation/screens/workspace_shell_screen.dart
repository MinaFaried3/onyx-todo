import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/core/ui/responsive/responsive_extension.dart';
import 'package:onyx_todo/feature/achievement/presentation/screens/achievement_screen.dart';
import 'package:onyx_todo/feature/excel_import/presentation/screens/excel_import_screen.dart';
import 'package:onyx_todo/feature/month_plan/presentation/screens/month_plan_screen.dart';
import 'package:onyx_todo/feature/task/presentation/screens/tasks_screen.dart';
import 'package:onyx_todo/feature/team/presentation/screens/team_management_screen.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';
import 'package:onyx_todo/feature/workspace/presentation/widgets/onyx_sidebar.dart';
import 'package:onyx_todo/feature/workspace/presentation/widgets/onyx_top_bar.dart';

class WorkspaceShellScreen extends HookWidget {
  const WorkspaceShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceCubit = context.workspaceCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    useEffect(() {
      workspaceCubit.init();
      return null;
    }, const []);

    final isMobile = context.isMobile;

    final canvas = Column(
      children: [
        // Top Navigation and Actions Bar
        const OnyxTopBar(),

        // Active Workspace Body Content
        Expanded(
          child: BlocBuilder<WorkspaceCubit, WorkspaceState>(
            buildWhen: (prev, curr) => prev.activeView != curr.activeView,
            builder: (context, state) {
              return switch (state.activeView) {
                WorkspaceView.achievements => const AchievementScreen(),
                WorkspaceView.monthlyPlan => const MonthPlanScreen(),
                WorkspaceView.excelImport => const ExcelImportScreen(),
                WorkspaceView.teamManagement => const TeamManagementScreen(),
                _ => const TasksScreen(),
              };
            },
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: isDark ? OnyxColors.darkBackground : OnyxColors.lightBackground,
      drawer: isMobile
          ? const Drawer(
              child: OnyxSidebar(isDrawer: true),
            )
          : null,
      body: isMobile
          ? SafeArea(child: canvas)
          : Row(
              children: [
                // Collapsible Onyx Navigation Sidebar
                const OnyxSidebar(),

                // Main App Canvas
                Expanded(child: canvas),
              ],
            ),
    );
  }
}
