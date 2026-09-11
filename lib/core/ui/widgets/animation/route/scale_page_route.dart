import 'package:flutter/material.dart';

class ScalePageRoute extends PageRouteBuilder {
  final WidgetBuilder builder;
  final Duration duration;
  final Duration reverseDuration;
  final Curve curve;
  final Color? transitionColor;
  final String? voiceLabel;
  final Tween<double>? tween;

  ScalePageRoute(
      {required this.builder,
      this.duration = const Duration(milliseconds: 500),
      this.reverseDuration = const Duration(milliseconds: 100),
      this.curve = Curves.easeOut,
      this.tween,
      this.transitionColor,
      this.voiceLabel})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final currentTween = tween ?? Tween<double>(begin: 0, end: 1.0);

            Animation<double> animationDouble =
                currentTween.animate(CurvedAnimation(
              parent: animation,
              curve: curve,
            ));

            return ScaleTransition(
              scale: animationDouble,
              child: child,
            );
          },
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          barrierColor: transitionColor,
          barrierLabel: voiceLabel,
        );
}
