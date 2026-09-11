import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/responsive/widgets/flexible_fitted.dart';
import 'package:onyx_todo/core/ui/styles_manager.dart';
import 'package:onyx_todo/core/ui/widgets/space.dart';

class Retry extends StatelessWidget {
  const Retry({super.key, required this.onPressed, required this.text});

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          // IconButton(
          //     onPressed: onPressed,
          //     icon: const AppSvg(
          //       color: ColorsManager.bluePrimary,
          //       height: 40,
          //       path: As.retryIcon,
          //     )),
          const VerticalSpace(20),
          FittedFlexible(child: Text(text, style: get500MediumStyle())),
        ],
      ),
    );
  }
}
