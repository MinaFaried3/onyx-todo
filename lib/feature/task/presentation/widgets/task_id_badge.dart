import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/clickup_colors.dart';

class TaskIdBadge extends StatelessWidget {
  final String formattedId;
  final VoidCallback? onTap;
  final bool isLarge;

  const TaskIdBadge({
    super.key,
    required this.formattedId,
    this.onTap,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Tooltip(
      message: AppStrings.copyId.tr(),
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: formattedId));
          context.safeShowSnackBar(
            SnackBar(content: Text(AppStrings.idCopied.tr())),
          );
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isLarge ? 10 : 7,
            vertical: isLarge ? 6 : 3,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? ClickUpColors.primaryDark.withValues(alpha: 0.25)
                : ClickUpColors.primaryLight,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: ClickUpColors.primary.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tag_rounded,
                size: isLarge ? 14 : 11,
                color: ClickUpColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                formattedId,
                style: TextStyle(
                  color: ClickUpColors.primary,
                  fontSize: isLarge ? 13 : 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
