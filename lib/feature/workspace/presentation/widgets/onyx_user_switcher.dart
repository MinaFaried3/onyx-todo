import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/localization/app_strings.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';
import 'package:onyx_todo/feature/auth/domain/entities/user_profile.dart';
import 'package:onyx_todo/feature/workspace/presentation/cubit/workspace_cubit.dart';

class OnyxUserSwitcher extends StatelessWidget {
  const OnyxUserSwitcher({
    required this.cubit,
    required this.currentUser,
    required this.users,
    required this.isDark,
    super.key,
  });

  final WorkspaceCubit cubit;
  final UserProfile currentUser;
  final List<UserProfile> users;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? OnyxColors.darkCard : OnyxColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? OnyxColors.darkBorder : OnyxColors.lightBorder,
        ),
      ),
      child: PopupMenuButton<String>(
        tooltip: AppStrings.switchAccount.tr(),
        onSelected: (uid) => cubit.switchUser(uid),
        itemBuilder: (ctx) => users.map((u) {
          return PopupMenuItem(
            value: u.id,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: OnyxColors.primary.withValues(alpha: 0.2),
                  child: Text(
                    u.name.substring(0, 1),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: OnyxColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      u.name,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${u.role.label} (${u.stack.label})',
                      style: const TextStyle(fontSize: 10, color: OnyxColors.neutral400),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: OnyxColors.primary,
              child: Text(
                currentUser.name.substring(0, 1),
                style: const TextStyle(
                  color: OnyxColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUser.name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    currentUser.role.label,
                    style: const TextStyle(fontSize: 10, color: OnyxColors.neutral400),
                  ),
                ],
              ),
            ),
            const FaIcon(FontAwesomeIcons.sort, size: 12, color: OnyxColors.neutral400),
          ],
        ),
      ),
    );
  }
}
