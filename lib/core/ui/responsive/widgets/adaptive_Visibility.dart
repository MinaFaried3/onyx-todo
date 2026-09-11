import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/responsive/break_points.dart';

class AdaptiveVisibility extends StatelessWidget {
  final Widget child;
  final bool showOnMobile;
  final bool showOnTablet;
  final bool showOnDesktop;

  const AdaptiveVisibility({
    super.key,
    required this.child,
    this.showOnMobile = true,
    this.showOnTablet = true,
    this.showOnDesktop = true,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final isMobile = width < Breakpoints.mobile;
    final isTablet = width >= Breakpoints.mobile && width < Breakpoints.desktop;
    final isDesktop = width >= Breakpoints.desktop;

    if ((isMobile && showOnMobile) ||
        (isTablet && showOnTablet) ||
        (isDesktop && showOnDesktop)) {
      return child;
    }

    return const SizedBox.shrink();
  }
}
