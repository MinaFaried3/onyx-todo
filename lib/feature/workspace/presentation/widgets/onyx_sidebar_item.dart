import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';

class OnyxSidebarItem extends StatelessWidget {
  const OnyxSidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final FaIconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? OnyxColors.primary.withValues(alpha: 0.12) : OnyxColors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            FaIcon(
              icon,
              size: 15,
              color: isSelected ? OnyxColors.primary : OnyxColors.neutral400,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? OnyxColors.primary : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
