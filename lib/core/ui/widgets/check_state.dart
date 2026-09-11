import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:onyx_todo/core/ui/widgets/animation/lottie_animation/loading_indicator.dart';

/// **CheckState**
///
/// **When to use**:
/// Use this wrapper widget on screens/containers that load data from a Cubit/Repository.
///
/// **Why to use**:
/// - Standardizes handling of loading, error, and success/content states.
/// - Reduces inline UI conditional checks.
/// - Fully customizable: inject custom loaders, custom error representations, and retry logic.
class CheckState extends StatelessWidget {
  final bool isError;
  final bool isLoading;
  final Widget child;
  final Widget? customErrWidget;
  final Widget? customLoaderWidget;
  final bool? canRetry;
  final void Function()? onClickRetry;

  CheckState({
    super.key,
    required this.isError,
    required this.isLoading,
    required this.child,
    this.customErrWidget,
    this.customLoaderWidget,
    this.canRetry,
    this.onClickRetry,
  });

  late final Widget _defaultErrWidget = Builder(
    builder: (context) => Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(fontSize: 16, fontWeight: .bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go('/');
            },
            child: const Text('Go to Splash'),
          ),
        ],
      ),
    ),
  );

  final Widget _defaultLoaderWidget = const Center(
    child: LoadingIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return customLoaderWidget ?? _defaultLoaderWidget;
    } else if (isError) {
      return Center(
        child: Column(
          mainAxisSize: .min,
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          children: [
            customErrWidget ?? _defaultErrWidget,
            if (canRetry ?? false) ...[
              const SizedBox(height: 16),
              IconButton(
                onPressed: onClickRetry,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ],
        ),
      );
    }
    return child;
  }
}
