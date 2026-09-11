import 'package:flutter/material.dart';

class SizePageRoute extends PageRouteBuilder {
  final WidgetBuilder builder;
  final Duration duration;
  final Duration reverseDuration;
  final Color? transitionColor;
  final String? voiceLabel;
  final AlignmentGeometry alignment; // Customizable alignment
  final Axis axis; // Customizable axis
  final Curve curve; // Customizable curve

  SizePageRoute({
    required this.builder,
    this.duration = const Duration(seconds: 5),
    this.reverseDuration = const Duration(milliseconds: 100),
    this.transitionColor,
    this.voiceLabel,
    this.alignment = Alignment.center, // Default alignment
    this.axis = Axis.vertical, // Default axis
    this.curve = Curves.easeOut, // Default curve
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return Align(
              alignment: alignment,
              child: SizeTransition(
                axis: axis,
                sizeFactor: curvedAnimation,
                child: child,
              ),
            );
          },
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          barrierColor: transitionColor,
          barrierLabel: voiceLabel, // renamed to voiceLabel
        );
}
