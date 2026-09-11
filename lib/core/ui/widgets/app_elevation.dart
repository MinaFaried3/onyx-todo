
import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/color_manager.dart';

class AppElevation extends StatelessWidget {
  final Widget child;
  final ShapeBorder? shape;
  final Color? color;
  final Color? shadowColor;
  final double? elevation;

  const AppElevation(
      {super.key,
      required this.child,
      this.shape,
      this.color,
      this.elevation,
      this.shadowColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation ?? 12,
      shadowColor: shadowColor ?? ColorsManager.grey100,
      shape: shape,
      color: color ?? Colors.transparent,
      child: child,
    );
  }
}
