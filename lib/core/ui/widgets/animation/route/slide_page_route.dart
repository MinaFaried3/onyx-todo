import 'package:flutter/material.dart';

class SlidePageRoute extends PageRouteBuilder {
  final WidgetBuilder builder;
  final Duration duration;
  final Duration reverseDuration;
  final Curve curve;
  final Tween<Offset>? tweenOffset;
  final Color? transitionColor;
  final String? voiceLabel;

  SlidePageRoute({
    required this.builder,
    this.duration = const Duration(milliseconds: 500),
    this.reverseDuration = const Duration(milliseconds: 100),
    this.tweenOffset,
    this.curve = Curves.easeOut,
    this.transitionColor,
    this.voiceLabel,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curvedAnimation =
                CurvedAnimation(parent: animation, curve: curve);

            var tween = tweenOffset ??
                Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero);

            var offsetAnimation = curvedAnimation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          barrierColor: transitionColor,
          barrierLabel: voiceLabel, // renamed to voiceLabel
        );
}
