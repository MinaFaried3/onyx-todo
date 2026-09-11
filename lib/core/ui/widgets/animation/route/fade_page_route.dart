import 'package:flutter/material.dart';

class FadePageRoute extends PageRouteBuilder {
  final WidgetBuilder builder;
  final AlignmentGeometry align;
  final Duration duration;
  final Duration reverseDuration;
  final Color? transitionColor;
  final String? voiceLabel;

  FadePageRoute(
      {required this.builder,
      this.align = Alignment.center,
      this.duration = const Duration(milliseconds: 500),
      this.reverseDuration = const Duration(milliseconds: 100),
      this.voiceLabel,
      this.transitionColor})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return Align(
              alignment: align,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          barrierColor: transitionColor,
          // accessibility tools (like VoiceOver on iOS) focus on the barrier.
          barrierLabel: voiceLabel,
        );
}
