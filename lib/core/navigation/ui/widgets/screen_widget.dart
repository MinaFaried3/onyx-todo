import 'package:onyx_todo/core/helper/printer_manager.dart';
import 'package:onyx_todo/core/ui/widgets/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ScreenWidget extends StatelessWidget {
  const ScreenWidget({
    super.key,
    required this.child,
    required this.state,
  });

  final Widget child;
  final GoRouterState state;

  // List of paths that should trigger an upgrade check
  static const List<String> entryPaths = [
    '/login',
    '/home',
    '/',
  ];

  @override
  Widget build(BuildContext context) {
    final isEntryRoute = entryPaths.contains(state.matchedLocation);

    return ConditionalBuilder(
      condition: isEntryRoute,
      onTrue: (context) {
        Printer.print(
          'ScreenWidget: [${state.matchedLocation}] is an Entry Route - Upgrade check could run here',
          color: ConsoleColor.brightBlue,
        );
        // Note: You can reintegrate AppUpgradeAlert here when ready
        return child;
      },
      onFalse: (context) => child,
    );
  }
}
