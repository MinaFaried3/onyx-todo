import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';

class _ModuleChartData {
  final String module;
  final int count;
  final Color color;

  _ModuleChartData(this.module, this.count, this.color);
}

class _DevHoursData {
  final String developer;
  final double estimatedHours;
  final double actualHours;

  _DevHoursData(this.developer, this.estimatedHours, this.actualHours);
}

class _StatusChartData {
  final String status;
  final int count;
  final Color color;

  _StatusChartData(this.status, this.count, this.color);
}

class ClickUpAnalyticsView extends HookWidget {
  final List<TaskEntity> tasks;

  const ClickUpAnalyticsView({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard;
    final borderColor = isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder;
    final textPrimary = isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary;
    final textSecondary = isDark ? ClickUpColors.darkTextSecondary : ClickUpColors.lightTextSecondary;

    // Aggregate KPI metrics
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.status == TaskStatus.closed).length;
    final totalEstHours = tasks.fold<double>(0.0, (s, t) => s + t.estimatedHours);
    final totalActHours = tasks.fold<double>(0.0, (s, t) => s + t.actualHours);
    final completionRate = totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;

    // 1. Module task distribution
    final Map<String, int> moduleCountMap = {};
    for (final t in tasks) {
      final m = t.moduleCode.isNotEmpty ? t.moduleCode : 'GENERAL';
      moduleCountMap[m] = (moduleCountMap[m] ?? 0) + 1;
    }
    final List<_ModuleChartData> moduleChartData = [];
    int colorIdx = 0;
    for (final entry in moduleCountMap.entries) {
      final color = ClickUpColors.chartPalette[colorIdx % ClickUpColors.chartPalette.length];
      moduleChartData.add(_ModuleChartData(entry.key, entry.value, color));
      colorIdx++;
    }

    // 2. Developer workload velocity (Estimated vs Actual)
    final Map<String, ({double est, double act})> devHoursMap = {};
    for (final t in tasks) {
      final dev = t.frontendDevName ?? t.backendDevName ?? AppStrings.unassigned.tr();
      final current = devHoursMap[dev] ?? (est: 0.0, act: 0.0);
      devHoursMap[dev] = (
        est: current.est + t.estimatedHours,
        act: current.act + t.actualHours,
      );
    }
    final List<_DevHoursData> devHoursData = devHoursMap.entries
        .map((e) => _DevHoursData(e.key, e.value.est, e.value.act))
        .toList();

    // 3. Status pipeline breakdown
    final List<_StatusChartData> statusChartData = TaskStatus.values.map((s) {
      final count = tasks.where((t) => t.status == s).length;
      return _StatusChartData(s.label, count, s.color);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header KPI Cards ──────────────────────────────────────────────
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 900;
              final crossAxisCount = isNarrow ? 2 : 5;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: isNarrow ? 2.0 : 2.4,
                children: [
                  _buildKpiCard(
                    title: AppStrings.totalTasksMetric.tr(),
                    value: '$totalTasks',
                    icon: FontAwesomeIcons.listCheck,
                    color: ClickUpColors.primary,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  _buildKpiCard(
                    title: AppStrings.completedTasksMetric.tr(),
                    value: '$completedTasks',
                    icon: FontAwesomeIcons.circleCheck,
                    color: ClickUpColors.success,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  _buildKpiCard(
                    title: AppStrings.estHoursMetric.tr(),
                    value: '${totalEstHours.toStringAsFixed(1)}h',
                    icon: FontAwesomeIcons.clock,
                    color: ClickUpColors.info,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  _buildKpiCard(
                    title: AppStrings.actHoursMetric.tr(),
                    value: '${totalActHours.toStringAsFixed(1)}h',
                    icon: FontAwesomeIcons.stopwatch,
                    color: ClickUpColors.warning,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  _buildKpiCard(
                    title: AppStrings.completionRateMetric.tr(),
                    value: '${(completionRate * 100).toStringAsFixed(0)}%',
                    icon: FontAwesomeIcons.chartLine,
                    color: ClickUpColors.accentPurple,
                    cardBg: cardBg,
                    borderColor: borderColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // ─── Charts Row 1: Module Share & Developer Hours ──────────────────
          LayoutBuilder(
            builder: (context, constraints) {
              final isStacked = constraints.maxWidth < 1000;

              return Flex(
                direction: isStacked ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Module Distribution
                  Expanded(
                    flex: isStacked ? 0 : 5,
                    child: Container(
                      height: 380,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.cubes, size: 16, color: ClickUpColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                AppStrings.moduleTaskDistribution.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: SfCircularChart(
                              legend: const Legend(
                                isVisible: true,
                                overflowMode: LegendItemOverflowMode.wrap,
                                position: LegendPosition.bottom,
                              ),
                              series: <CircularSeries>[
                                DoughnutSeries<_ModuleChartData, String>(
                                  dataSource: moduleChartData,
                                  xValueMapper: (_ModuleChartData data, _) => data.module,
                                  yValueMapper: (_ModuleChartData data, _) => data.count,
                                  pointColorMapper: (_ModuleChartData data, _) => data.color,
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    labelPosition: ChartDataLabelPosition.outside,
                                  ),
                                  enableTooltip: true,
                                  innerRadius: '60%',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: isStacked ? 0 : 20, height: isStacked ? 20 : 0),

                  // Developer Velocity (Estimated vs Actual)
                  Expanded(
                    flex: isStacked ? 0 : 7,
                    child: Container(
                      height: 380,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.userCheck, size: 16, color: ClickUpColors.info),
                              const SizedBox(width: 8),
                              Text(
                                AppStrings.developerVelocity.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: SfCartesianChart(
                              primaryXAxis: const CategoryAxis(
                                labelRotation: -20,
                              ),
                              primaryYAxis: const NumericAxis(
                                title: AxisTitle(text: 'Hours'),
                              ),
                              legend: const Legend(
                                isVisible: true,
                                position: LegendPosition.top,
                              ),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <CartesianSeries>[
                                ColumnSeries<_DevHoursData, String>(
                                  name: AppStrings.estHoursMetric.tr(),
                                  dataSource: devHoursData,
                                  xValueMapper: (_DevHoursData data, _) => data.developer,
                                  yValueMapper: (_DevHoursData data, _) => data.estimatedHours,
                                  color: ClickUpColors.info,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                                ColumnSeries<_DevHoursData, String>(
                                  name: AppStrings.actHoursMetric.tr(),
                                  dataSource: devHoursData,
                                  xValueMapper: (_DevHoursData data, _) => data.developer,
                                  yValueMapper: (_DevHoursData data, _) => data.actualHours,
                                  color: ClickUpColors.warning,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // ─── Charts Row 2: Status Pipeline Breakdown ──────────────────────
          Container(
            height: 320,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.barsProgress, size: 16, color: ClickUpColors.accentPurple),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.statusPipelineBreakdown.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SfCartesianChart(
                    primaryXAxis: const CategoryAxis(),
                    primaryYAxis: const NumericAxis(),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries>[
                      BarSeries<_StatusChartData, String>(
                        dataSource: statusChartData,
                        xValueMapper: (_StatusChartData data, _) => data.status,
                        yValueMapper: (_StatusChartData data, _) => data.count,
                        pointColorMapper: (_StatusChartData data, _) => data.color,
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(6)),
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: FaIcon(icon, size: 18, color: color),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
