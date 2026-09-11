
import 'package:flutter/material.dart';

class AppSlidingWidget extends StatefulWidget {
  const AppSlidingWidget(
      {super.key, required this.duration, required this.child});

  final Duration duration;
  final Widget child;

  @override
  State<AppSlidingWidget> createState() => _AppSlidingWidgetState();
}

class _AppSlidingWidgetState extends State<AppSlidingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<Offset> animation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: widget.duration);
    animation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeInOutCubic));

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: widget.child,
    );
  }
}
