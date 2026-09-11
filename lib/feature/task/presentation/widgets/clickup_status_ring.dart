import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onyx_todo/core/enum/task_enums.dart';
import 'package:onyx_todo/core/ui/onyx_colors.dart';

class ClickUpStatusRing extends StatelessWidget {
  final TaskStatus status;
  final double size;
  final VoidCallback? onTap;

  const ClickUpStatusRing({
    super.key,
    required this.status,
    this.size = 18,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    final isClosed = status == TaskStatus.closed;
    final isSolved = status == TaskStatus.backendSolved || status == TaskStatus.frontendSolved;

    Widget ringContent;
    if (isClosed) {
      ringContent = Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: OnyxColors.success,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FaIcon(
            FontAwesomeIcons.check,
            size: size * 0.55,
            color: Colors.white,
          ),
        ),
      );
    } else if (isSolved) {
      ringContent = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Center(
          child: Container(
            width: size * 0.45,
            height: size * 0.45,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    } else {
      ringContent = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Center(
          child: Container(
            width: size * 0.35,
            height: size * 0.35,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size),
        child: ringContent,
      );
    }

    return ringContent;
  }
}
