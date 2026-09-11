import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/bloc_reader.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';
import 'package:onyx_todo/feature/excel_import/presentation/cubit/excel_import_cubit.dart';
import 'package:onyx_todo/feature/excel_import/presentation/cubit/excel_import_state.dart';
import 'package:onyx_todo/feature/task/presentation/widgets/task_id_badge.dart';

class ExcelImportScreen extends HookWidget {
  const ExcelImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final excelImportCubit = context.excelImportCubit;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<ExcelImportCubit, ExcelImportState>(
      builder: (context, state) {
        final isLoading = state.importState.isLoading;
        final isSuccess = state.importState.isSucceed;
        final previewTasks = state.previewTasks;
        final sheetsFound = state.sheetsFound;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.fileExcel, color: ClickUpColors.success, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.excelImport.tr(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          AppStrings.uploadExcelPrompt.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? ClickUpColors.neutral400 : ClickUpColors.neutral500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Upload Card / Dropzone
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ClickUpColors.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.cloudArrowUp,
                        size: 48,
                        color: ClickUpColors.primary.withValues(alpha: 0.8),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        AppStrings.uploadExcelPrompt.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ClickUpColors.primary,
                          foregroundColor: ClickUpColors.lightCard,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        icon: isLoading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: ClickUpColors.lightCard,
                                ),
                              )
                            : const FaIcon(FontAwesomeIcons.folderOpen, size: 14),
                        label: Text(
                          isLoading ? AppStrings.importingTasks.tr() : AppStrings.selectExcelFile.tr(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                final result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['xlsx', 'xls'],
                                  withData: true,
                                );

                                if (result != null && result.files.isNotEmpty) {
                                  final file = result.files.first;
                                  final bytes = file.bytes;
                                  if (bytes != null) {
                                    excelImportCubit.processExcelBytes(bytes, file.name);
                                  }
                                }
                              },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Success notification banner
                if (isSuccess) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ClickUpColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ClickUpColors.success),
                    ),
                    child: Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.circleCheck, color: ClickUpColors.success, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            AppStrings.tasksImportedSuccess.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: ClickUpColors.success),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.tasksCubit.fetchTasks();
                            context.safeShowSnackBar(SnackBar(content: Text(AppStrings.tasksUpdatedSuccess.tr())));
                          },
                          child: Text(AppStrings.viewTasksBoard.tr()),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Discovered Sheets Chips
                if (sheetsFound.isNotEmpty) ...[
                  Text(
                    '${AppStrings.sheetsFound.tr()} (${sheetsFound.length}):',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: sheetsFound.map((code) {
                      return Chip(
                        label: Text(code, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        backgroundColor: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
                        side: BorderSide(color: ClickUpColors.primary.withValues(alpha: 0.3)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Preview Table
                if (previewTasks.isNotEmpty) ...[
                  Text(
                    '${AppStrings.tasksImported.tr()} (${previewTasks.length}):',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? ClickUpColors.darkCard : ClickUpColors.lightCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: previewTasks.length > 50 ? 50 : previewTasks.length,
                        itemBuilder: (context, index) {
                          final t = previewTasks[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isDark ? ClickUpColors.darkBorder : ClickUpColors.lightBorder,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                TaskIdBadge(formattedId: t.formattedId),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isDark ? ClickUpColors.neutral700 : ClickUpColors.neutral200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    t.moduleCode,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? ClickUpColors.neutral300 : ClickUpColors.neutral700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: ClickUpColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    t.screenName,
                                    style: const TextStyle(fontSize: 10, color: ClickUpColors.primary),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    t.title,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? ClickUpColors.darkTextPrimary : ClickUpColors.lightTextPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (t.frontendDevName != null) ...[
                                  Text(
                                    t.frontendDevName!,
                                    style: const TextStyle(fontSize: 10, color: ClickUpColors.teal),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                if (t.backendDevName != null) ...[
                                  Text(
                                    t.backendDevName!,
                                    style: const TextStyle(fontSize: 10, color: ClickUpColors.purple),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  t.status.label,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: t.status.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
