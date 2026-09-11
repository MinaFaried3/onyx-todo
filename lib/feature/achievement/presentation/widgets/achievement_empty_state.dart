import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';

class AchievementEmptyState extends StatelessWidget {
  final bool isDark;

  const AchievementEmptyState({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.newspaper,
            size: 48,
            color: isDark ? OnyxColors.neutral600 : OnyxColors.neutral400,
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.noAchievementsFound.tr(),
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
}
