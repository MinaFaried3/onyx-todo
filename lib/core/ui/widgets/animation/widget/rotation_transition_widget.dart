
import 'package:flutter/material.dart';

class RotationTransitionWidget extends StatefulWidget {
  const RotationTransitionWidget(
      {super.key,
      required this.child,
      this.duration = const Duration(seconds: 1),
      this.curve = Curves.easeOut,
      this.tween,
      this.rotationCount = 1});

  final Widget child;
  final Duration duration;
  final Curve curve;
  final Tween<double>? tween;
  //How many you want to rotate
  final double rotationCount;

  @override
  State<RotationTransitionWidget> createState() =>
      _RotationTransitionWidgetState();
}

class _RotationTransitionWidgetState extends State<RotationTransitionWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = getTween().animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _controller.forward();
  }

  Tween<double> getTween() =>
      widget.tween ?? Tween<double>(begin: 0, end: widget.rotationCount);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: widget.child,
    );
  }
}
