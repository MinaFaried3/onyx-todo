import 'package:onyx_todo/core/localization/core_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


class UndefinedRouteScreen extends StatelessWidget {
  final Exception? error;

  /// Callback للتنقل للشاشة الرئيسية — يحدده التطبيق
  final VoidCallback? onGoHome;

  const UndefinedRouteScreen({super.key, this.error, this.onGoHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.route_outlined,
                size: 100,
                color: Colors.grey,
              ),
              const SizedBox(height: 24),
              Text(
                CoreStrings.noRoute.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    error.toString(),
                    style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onGoHome ?? () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.home_outlined),
                  label: Text(CoreStrings.goHome.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
