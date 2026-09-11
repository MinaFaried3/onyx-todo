import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/task/domain/entities/task_entity.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/developer_workload_card.dart';

class OnyxWorkloadView extends StatelessWidget {
  final List<TaskEntity> tasks;

  const OnyxWorkloadView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Aggregate workload per developer
    final Map<String, List<TaskEntity>> devTasks = {};

    for (final task in tasks) {
      if (task.frontendDevName != null && task.frontendDevName!.isNotEmpty) {
        devTasks.putIfAbsent(task.frontendDevName!, () => []).add(task);
      }
      if (task.backendDevName != null && task.backendDevName!.isNotEmpty) {
        devTasks.putIfAbsent(task.backendDevName!, () => []).add(task);
      }
      if (task.middleDevName != null && task.middleDevName!.isNotEmpty) {
        devTasks.putIfAbsent(task.middleDevName!, () => []).add(task);
      }
    }

    if (devTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.userGroup,
              size: 48,
              color: isDark ? OnyxColors.neutral600 : OnyxColors.neutral400,
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.noDevelopersAssigned.tr(),
              style: TextStyle(
                fontSize: 14,
                color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: devTasks.entries.map((entry) {
        return DeveloperWorkloadCard(
          devName: entry.key,
          tasks: entry.value,
          isDark: isDark,
        );
      }).toList(),
    );
  }
}
