import 'package:onyx_todo/core/navigation/navigation_packages.dart';
import 'package:flutter/material.dart';

class RouterErrorScreen extends StatelessWidget {
  const RouterErrorScreen({super.key, required this.state,this.defaultRoute ='/'});

  final GoRouterState state;
  final String defaultRoute;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${state.uri} does not exist'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                  context.go(defaultRoute);
              },
              child: const Text('Go to home'),
            ),
          ],
        ),
      ),
    );
  }
}
