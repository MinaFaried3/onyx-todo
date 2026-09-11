
import 'package:flutter/material.dart';

class SizeTransitionWidget extends StatefulWidget {
  const SizeTransitionWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 900),
    this.curve = Curves.easeOut,
    this.tween,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final Tween<double>? tween;

  @override
  State<SizeTransitionWidget> createState() => _SizeTransitionWidgetState();
}

class _SizeTransitionWidgetState extends State<SizeTransitionWidget>
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

  Tween<double> getTween() => widget.tween ?? Tween<double>(begin: 0, end: 1);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      child: widget.child,
    );
  }
}
