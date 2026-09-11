import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';

class OnyxViewTab extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const OnyxViewTab({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? OnyxColors.primary.withValues(alpha: 0.12)
              : OnyxColors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border.all(color: OnyxColors.primary.withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          children: [
            FaIcon(
              icon,
              size: 13,
              color: isSelected ? OnyxColors.primary : OnyxColors.neutral400,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? OnyxColors.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
