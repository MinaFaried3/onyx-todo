import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/summary_metric_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OnyxAnalyticsView extends StatelessWidget {
  final List<TaskEntity> tasks;

  const OnyxAnalyticsView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? OnyxColors.darkCard : OnyxColors.lightCard;
    final borderColor = isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder;
    final textPrimary = isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary;
    final textSecondary = isDark ? OnyxColors.neutral400 : OnyxColors.neutral500;

    // 1. Calculate Summary Metrics
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.status == TaskStatus.closed || t.status == TaskStatus.backendSolved).length;
    final totalEstHours = tasks.fold<double>(0.0, (s, t) => s + t.estimatedHours);
    final totalActHours = tasks.fold<double>(0.0, (s, t) => s + t.actualHours);
    final completionRate = totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;

    // 2. Aggregate Module Task Distribution
    final Map<String, int> moduleCountMap = {};
    for (final t in tasks) {
      moduleCountMap[t.moduleCode] = (moduleCountMap[t.moduleCode] ?? 0) + 1;
    }
    final moduleData = moduleCountMap.entries
        .map((e) => _ModuleChartData(module: e.key, taskCount: e.value))
        .toList()
      ..sort((a, b) => b.taskCount.compareTo(a.taskCount));

    // 3. Aggregate Status Pipeline
    final Map<TaskStatus, int> statusCountMap = {};
    for (final status in TaskStatus.values) {
      statusCountMap[status] = 0;
    }
    for (final t in tasks) {
      statusCountMap[t.status] = (statusCountMap[t.status] ?? 0) + 1;
    }
    final statusData = TaskStatus.values
        .map((s) => _StatusChartData(
              statusLabel: s.label,
              taskCount: statusCountMap[s] ?? 0,
              color: s.color,
            ))
        .toList();

    // 4. Aggregate Developer Workload (Estimated vs Actual)
    final Map<String, _DevHoursAccumulator> devMap = {};
    for (final t in tasks) {
      if (t.frontendDevName != null && t.frontendDevName!.isNotEmpty) {
        final acc = devMap.putIfAbsent(t.frontendDevName!, () => _DevHoursAccumulator());
        acc.est += t.estimatedHours;
        acc.act += t.actualHours;
      }
      if (t.backendDevName != null && t.backendDevName!.isNotEmpty) {
        final acc = devMap.putIfAbsent(t.backendDevName!, () => _DevHoursAccumulator());
        acc.est += t.estimatedHours;
        acc.act += t.actualHours;
      }
    }
    final devData = devMap.entries
        .map((e) => _DevVelocityData(
              devName: e.key,
              estHours: e.value.est,
              actHours: e.value.act,
            ))
        .toList()
      ..sort((a, b) => (b.estHours + b.actHours).compareTo(a.estHours + a.actHours));

    // Responsive layout detection
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 900;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Section Header
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.chartPie, color: OnyxColors.primary, size: 20),
            const SizedBox(width: 10),
            Text(
              AppStrings.chartsAndMetrics.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // KPI Summary Cards
        LayoutBuilder(
          builder: (context, constraints) {
            final colCount = constraints.maxWidth < 600 ? 2 : (constraints.maxWidth < 1100 ? 3 : 5);
            return GridView.count(
              crossAxisCount: colCount,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: isNarrow ? 2.0 : 2.4,
              children: [
                SummaryMetricCard(
                  title: AppStrings.totalTasksMetric.tr(),
                  value: '$totalTasks',
                  icon: FontAwesomeIcons.listCheck,
                  color: OnyxColors.primary,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                SummaryMetricCard(
                  title: AppStrings.completedTasksMetric.tr(),
                  value: '$completedTasks',
                  icon: FontAwesomeIcons.circleCheck,
                  color: OnyxColors.success,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                SummaryMetricCard(
                  title: AppStrings.estHoursMetric.tr(),
                  value: '${totalEstHours.toStringAsFixed(1)}h',
                  icon: FontAwesomeIcons.clock,
                  color: OnyxColors.info,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                SummaryMetricCard(
                  title: AppStrings.actHoursMetric.tr(),
                  value: '${totalActHours.toStringAsFixed(1)}h',
                  icon: FontAwesomeIcons.stopwatch,
                  color: OnyxColors.warning,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                SummaryMetricCard(
                  title: AppStrings.completionRateMetric.tr(),
                  value: '${(completionRate * 100).toStringAsFixed(0)}%',
                  icon: FontAwesomeIcons.chartLine,
                  color: OnyxColors.accentPurple,
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

        // Charts Section 1: Module Share (Doughnut) & Status Pipeline (Bar)
        if (isNarrow) ...[
          _buildModuleDoughnutCard(moduleData, cardBg, borderColor, textPrimary, textSecondary),
          const SizedBox(height: 16),
          _buildStatusPipelineCard(statusData, cardBg, borderColor, textPrimary, textSecondary),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: _buildModuleDoughnutCard(moduleData, cardBg, borderColor, textPrimary, textSecondary),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 6,
                child: _buildStatusPipelineCard(statusData, cardBg, borderColor, textPrimary, textSecondary),
              ),
            ],
          ),
        const SizedBox(height: 24),

        // Charts Section 2: Developer Velocity (Estimated vs Actual) Column Chart
        _buildDeveloperVelocityCard(devData, cardBg, borderColor, textPrimary, textSecondary),
      ],
    );
  }

  Widget _buildModuleDoughnutCard(
    List<_ModuleChartData> data,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
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
              const FaIcon(FontAwesomeIcons.cubes, size: 14, color: OnyxColors.primary),
              const SizedBox(width: 8),
              Text(
                AppStrings.moduleTaskDistribution.tr(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 280,
            child: data.isEmpty
                ? Center(
                    child: Text(
                      AppStrings.noTasksFound.tr(),
                      style: TextStyle(color: textSecondary),
                    ),
                  )
                : SfCircularChart(
                    legend: const Legend(
                      isVisible: true,
                      overflowMode: LegendItemOverflowMode.wrap,
                      position: LegendPosition.bottom,
                    ),
                    palette: OnyxColors.chartPalette,
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CircularSeries<_ModuleChartData, String>>[
                      DoughnutSeries<_ModuleChartData, String>(
                        dataSource: data.take(8).toList(),
                        xValueMapper: (_ModuleChartData item, _) => item.module,
                        yValueMapper: (_ModuleChartData item, _) => item.taskCount,
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                        ),
                        enableTooltip: true,
                        innerRadius: '60%',
                        radius: '85%',
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPipelineCard(
    List<_StatusChartData> data,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
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
              const FaIcon(FontAwesomeIcons.barsProgress, size: 14, color: OnyxColors.info),
              const SizedBox(width: 8),
              Text(
                AppStrings.statusPipelineBreakdown.tr(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 280,
            child: SfCartesianChart(
              primaryXAxis: const CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
                labelRotation: -20,
              ),
              primaryYAxis: const NumericAxis(
                majorGridLines: MajorGridLines(width: 0.5, dashArray: [4, 4]),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<_StatusChartData, String>>[
                ColumnSeries<_StatusChartData, String>(
                  dataSource: data,
                  xValueMapper: (_StatusChartData item, _) => item.statusLabel,
                  yValueMapper: (_StatusChartData item, _) => item.taskCount,
                  pointColorMapper: (_StatusChartData item, _) => item.color,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperVelocityCard(
    List<_DevVelocityData> data,
    Color cardBg,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
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
              const FaIcon(FontAwesomeIcons.userCheck, size: 14, color: OnyxColors.success),
              const SizedBox(width: 8),
              Text(
                AppStrings.developerVelocity.tr(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary),
              ),
              const Spacer(),
              Text(
                AppStrings.estimatedVsActualHours.tr(),
                style: TextStyle(fontSize: 12, color: textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: data.isEmpty
                ? Center(
                    child: Text(
                      AppStrings.noDevelopersAssigned.tr(),
                      style: TextStyle(color: textSecondary),
                    ),
                  )
                : SfCartesianChart(
                    legend: const Legend(
                      isVisible: true,
                      position: LegendPosition.top,
                    ),
                    primaryXAxis: const CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      labelRotation: -15,
                    ),
                    primaryYAxis: const NumericAxis(
                      title: AxisTitle(text: 'Hours (h)'),
                      majorGridLines: MajorGridLines(width: 0.5, dashArray: [4, 4]),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries<_DevVelocityData, String>>[
                      ColumnSeries<_DevVelocityData, String>(
                        name: AppStrings.estLabel.tr(),
                        dataSource: data.take(10).toList(),
                        xValueMapper: (_DevVelocityData item, _) => item.devName,
                        yValueMapper: (_DevVelocityData item, _) => item.estHours,
                        color: OnyxColors.info,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                      ColumnSeries<_DevVelocityData, String>(
                        name: AppStrings.actLabel.tr(),
                        dataSource: data.take(10).toList(),
                        xValueMapper: (_DevVelocityData item, _) => item.devName,
                        yValueMapper: (_DevVelocityData item, _) => item.actHours,
                        color: OnyxColors.success,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _DevHoursAccumulator {
  double est = 0.0;
  double act = 0.0;
}

class _ModuleChartData {
  final String module;
  final int taskCount;
  _ModuleChartData({required this.module, required this.taskCount});
}

class _StatusChartData {
  final String statusLabel;
  final int taskCount;
  final Color color;
  _StatusChartData({required this.statusLabel, required this.taskCount, required this.color});
}

class _DevVelocityData {
  final String devName;
  final double estHours;
  final double actHours;
  _DevVelocityData({required this.devName, required this.estHours, required this.actHours});
}
