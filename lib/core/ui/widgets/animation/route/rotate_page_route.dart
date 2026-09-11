import 'package:flutter/material.dart';

class RotatePageRoute extends PageRouteBuilder {
  final WidgetBuilder builder;
  final Duration duration;
  final Duration reverseDuration;
  final Curve curve;
  final Color? transitionColor;
  final String? voiceLabel;
  final double rotateCount;
  final Tween<double>? tween;

  RotatePageRoute({
    required this.builder,
    this.duration = const Duration(milliseconds: 500),
    this.reverseDuration = const Duration(milliseconds: 100),
    this.curve = Curves.easeOut,
    this.rotateCount = 1,
    this.tween,
    this.transitionColor,
    this.voiceLabel,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final currentTween =
                tween ?? Tween<double>(begin: 0, end: rotateCount);

            Animation<double> animationDouble =
                currentTween.animate(CurvedAnimation(
              parent: animation,
              curve: curve,
            ));

            return RotationTransition(
              turns: animationDouble,
              child: child,
            );
          },
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          barrierColor: transitionColor,
          barrierLabel: voiceLabel, // renamed to voiceLabel
        );
}
