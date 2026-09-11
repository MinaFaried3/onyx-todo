import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';

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
      message: AppStrings.copyTaskId.tr(),
      child: Material(
        color: OnyxColors.transparent,
        child: InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: formattedId));
            context.safeShowSnackBar(
              SnackBar(
                backgroundColor: OnyxColors.darkCard,
                content: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.circleCheck, size: 14, color: OnyxColors.success),
                    const SizedBox(width: 8),
                    Text(
                      '${AppStrings.idCopied.tr()} ($formattedId)',
                      style: const TextStyle(color: OnyxColors.white),
                    ),
                  ],
                ),
              ),
            );
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(6),
          hoverColor: OnyxColors.primary.withValues(alpha: 0.15),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isLarge ? 10 : 7,
              vertical: isLarge ? 6 : 3,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? OnyxColors.primaryDark.withValues(alpha: 0.25)
                  : OnyxColors.primaryLight,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: OnyxColors.primary.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.hashtag,
                  size: isLarge ? 12 : 10,
                  color: OnyxColors.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  formattedId,
                  style: TextStyle(
                    color: OnyxColors.primary,
                    fontSize: isLarge ? 13 : 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 4),
                FaIcon(
                  FontAwesomeIcons.copy,
                  size: isLarge ? 11 : 9,
                  color: OnyxColors.primary.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
