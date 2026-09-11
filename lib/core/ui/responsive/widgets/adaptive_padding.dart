import 'package:flutter/material.dart';

class AdaptivePadding extends StatelessWidget {
  final Widget child;

  const AdaptivePadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final padding = switch (width) {
      < 600  => const EdgeInsets.all(16),
      < 1200 => const EdgeInsets.all(24),
      _      => const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
    };

    return Padding(padding: padding, child: child);
  }
}
