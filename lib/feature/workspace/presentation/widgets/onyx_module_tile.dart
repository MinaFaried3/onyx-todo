import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';

class OnyxModuleTile extends StatelessWidget {
  const OnyxModuleTile({
    required this.code,
    required this.name,
    required this.isSelected,
    required this.onTap,
    this.onOpenHierarchy,
    super.key,
  });

  final String code;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onOpenHierarchy;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? OnyxColors.primary.withValues(alpha: 0.15) : OnyxColors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? OnyxColors.primary : OnyxColors.neutral500.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                code,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? OnyxColors.white : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? OnyxColors.primary : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onOpenHierarchy != null) ...[
              const SizedBox(width: 4),
              InkWell(
                onTap: onOpenHierarchy,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: FaIcon(
                    FontAwesomeIcons.sitemap,
                    size: 11,
                    color: isSelected ? OnyxColors.primary : OnyxColors.neutral400,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
