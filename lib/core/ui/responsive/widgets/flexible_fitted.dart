
import 'package:flutter/material.dart';

class FittedFlexible extends StatelessWidget {
  const FittedFlexible({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: FittedBox(
      child: child,
    ));
  }
}
