
import 'package:flutter/material.dart';

class ConditionalBuilder extends StatelessWidget {
  const ConditionalBuilder(
      {super.key,
      required this.condition,
      required this.onTrue,
      required this.onFalse});

  final bool condition;
  final WidgetBuilder onTrue;
  final WidgetBuilder onFalse;

  @override
  Widget build(BuildContext context) {
    return condition ? onTrue(context) : onFalse(context);
  }
}
