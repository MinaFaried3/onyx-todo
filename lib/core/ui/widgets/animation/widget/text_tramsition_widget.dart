
import 'package:flutter/material.dart';

class TextTransitionWidget extends StatefulWidget {
  const TextTransitionWidget({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.curve = Curves.easeOut,
    this.styleBegin,
    this.styleEnd,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final TextStyle? styleBegin;
  final TextStyle? styleEnd;

  @override
  State<TextTransitionWidget> createState() => _TextTransitionWidgetState();
}

class _TextTransitionWidgetState extends State<TextTransitionWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<TextStyle> _animationStyle;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animationStyle = TextStyleTween(
      begin: widget.styleBegin ??
          const TextStyle(
              fontSize: 26, color: Colors.black, fontWeight: .bold),
      end: widget.styleEnd ??
          const TextStyle(
              fontSize: 36, color: Colors.red, fontWeight: .normal),
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyleTransition(
      style: _animationStyle,
      child: widget.child,
    );
  }
}
