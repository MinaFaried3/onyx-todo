import 'package:flutter/material.dart';
import 'package:onyx_todo/core/helper/constants.dart';

class PositionedTransitionWidget extends StatefulWidget {
  const PositionedTransitionWidget({
    super.key,
    required this.child,
    this.duration = DurationManager.m500,
    this.curve = Curves.easeOut,
    this.childRect,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final RelativeRectTween? childRect;

  @override
  State<PositionedTransitionWidget> createState() =>
      _PositionedTransitionWidgetState();
}

class _PositionedTransitionWidgetState extends State<PositionedTransitionWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<RelativeRect> childRect;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    childRect = getRelativeRectTween().animate(
        CurvedAnimation(parent: animationController, curve: widget.curve));

    start();
  }

  RelativeRectTween getRelativeRectTween() {
    return widget.childRect ??
        RelativeRectTween(
            begin: const RelativeRect.fromLTRB(0, 0, 0, 0),
            end: const RelativeRect.fromLTRB(300, 300, 0, 0));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void start() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(rect: childRect, child: widget.child);
  }
}
