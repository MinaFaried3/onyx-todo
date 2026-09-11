import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';

class AssigneeInfoRow extends StatelessWidget {
  final String label;
  final String name;
  final FaIconData icon;
  final Color color;

  const AssigneeInfoRow({
    super.key,
    required this.label,
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: FaIcon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? OnyxColors.neutral400 : OnyxColors.neutral500,
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? OnyxColors.darkTextPrimary : OnyxColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
