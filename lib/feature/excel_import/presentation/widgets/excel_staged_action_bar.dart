import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';

class ExcelStagedActionBar extends StatelessWidget {
  final bool isUploading;
  final double uploadProgress;
  final int uploadedCount;
  final int totalCount;
  final VoidCallback onConfirm;
  final VoidCallback onDiscard;

  const ExcelStagedActionBar({
    super.key,
    required this.isUploading,
    required this.uploadProgress,
    required this.uploadedCount,
    required this.totalCount,
    required this.onConfirm,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isUploading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: OnyxColors.primary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppStrings.uploadProgressLabel.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$uploadedCount / $totalCount (${(uploadProgress * 100).toStringAsFixed(0)}%)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: OnyxColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: uploadProgress > 0 ? uploadProgress : null,
                minHeight: 8,
                backgroundColor: isDark ? OnyxColors.neutral700 : OnyxColors.neutral200,
                color: OnyxColors.primary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? OnyxColors.darkCard : OnyxColors.lightCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.circleInfo, size: 16, color: OnyxColors.info),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppStrings.stagedPreviewNotice.tr(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? OnyxColors.neutral300 : OnyxColors.neutral700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: OnyxColors.statusClosed,
              side: const BorderSide(color: OnyxColors.statusClosed),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const FaIcon(FontAwesomeIcons.trashCan, size: 13),
            label: Text(
              AppStrings.discardImport.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            onPressed: onDiscard,
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: OnyxColors.primary,
              foregroundColor: OnyxColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const FaIcon(FontAwesomeIcons.cloudArrowUp, size: 14),
            label: Text(
              AppStrings.confirmImport.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            onPressed: onConfirm,
          ),
        ],
      ),
    );
  }
}
