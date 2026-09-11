import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';

class AssigneeAvatarBadge extends StatelessWidget {
  final String name;
  final double size;
  final String? photoUrl;

  const AssigneeAvatarBadge({
    super.key,
    required this.name,
    this.size = 24,
    this.photoUrl,
  });

  String _getInitials(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return 'U';
    final parts = clean.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final first = parts[0].isNotEmpty ? parts[0][0] : '';
      final second = parts[1].isNotEmpty ? parts[1][0] : '';
      return '$first$second'.toUpperCase();
    }
    return clean.substring(0, clean.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    final bgColor = OnyxColors.getAvatarColor(name);

    return Tooltip(
      message: name,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            initials,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.42,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ),
    );
  }
}
