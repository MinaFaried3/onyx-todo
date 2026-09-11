import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';

class ExcelUploadDropzone extends StatelessWidget {
  final bool isLoading;
  final void Function(Uint8List bytes, String fileName) onFileSelected;

  const ExcelUploadDropzone({
    super.key,
    required this.isLoading,
    required this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: OnyxColors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          FaIcon(
            FontAwesomeIcons.cloudArrowUp,
            size: 48,
            color: OnyxColors.primary.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 14),
          Text(
            AppStrings.uploadExcelPrompt.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: OnyxColors.primary,
              foregroundColor: OnyxColors.lightCard,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: OnyxColors.lightCard,
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
                        onFileSelected(bytes, file.name);
                      }
                    }
                  },
          ),
        ],
      ),
    );
  }
}
