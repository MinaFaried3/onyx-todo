import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/achievement/presentation/screens/achievement_screen.dart';
import 'package:onyx_todo/feature/excel_import/presentation/screens/excel_import_screen.dart';
import 'package:onyx_todo/feature/month_plan/presentation/screens/month_plan_screen.dart';
import 'package:onyx_todo/feature/task/presentation/screens/tasks_screen.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_state.dart';
import 'package:onyx_todo/feature/workspace/presentation/widgets/clickup_sidebar.dart';
import 'package:onyx_todo/feature/workspace/presentation/widgets/clickup_top_bar.dart';

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

    return Scaffold(
      backgroundColor: isDark ? ClickUpColors.darkBackground : ClickUpColors.lightBackground,
      body: Row(
        children: [
          // Collapsible ClickUp Navigation Sidebar
          const ClickUpSidebar(),

          // Main App Canvas
          Expanded(
            child: Column(
              children: [
                // Top Navigation and Actions Bar
                const ClickUpTopBar(),

                // Active Workspace Body Content
                Expanded(
                  child: BlocBuilder<WorkspaceCubit, WorkspaceState>(
                    buildWhen: (prev, curr) => prev.activeView != curr.activeView,
                    builder: (context, state) {
                      return switch (state.activeView) {
                        WorkspaceView.achievements => const AchievementScreen(),
                        WorkspaceView.monthlyPlan => const MonthPlanScreen(),
                        WorkspaceView.excelImport => const ExcelImportScreen(),
                        _ => const TasksScreen(),
                      };
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
