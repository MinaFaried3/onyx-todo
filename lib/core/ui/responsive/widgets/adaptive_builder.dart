import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/responsive/break_points.dart';
import 'package:onyx_todo/core/ui/responsive/responsive_extension.dart';

typedef ResponsiveBuilder = Widget Function(BuildContext context);

class AdaptiveBuilder extends StatelessWidget {
  final ResponsiveBuilder mobile;
  final ResponsiveBuilder? tablet;
  final ResponsiveBuilder? desktop;

  const AdaptiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final width = context.width;

    if (width <= Breakpoints.mobile) {
      return mobile(context);
    }

    if (width < Breakpoints.desktop) {
      return (tablet ?? mobile)(context);
    }

    return (desktop ?? tablet ?? mobile)(context);
  }
}
