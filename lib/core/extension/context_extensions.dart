export 'package:onyx_todo/core/utils/image_picker/image_picker_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

extension SafeContext on BuildContext {
  BuildContext? get safe {
    if (mounted) return this;
    return GetIt.I<GlobalKey<NavigatorState>>().currentContext;
  }

  bool ifMounted(void Function(BuildContext context) action) {
    if (!mounted) return false;
    action(this);
    return true;
  }

  bool ifMountedSafe(void Function(BuildContext context) action) {
    final ctx = safe;
    if (ctx == null) return false;
    action(ctx);
    return true;
  }

  T? readIfMounted<T>(T Function(BuildContext context) read) {
    if (!mounted) return null;
    try {
      return read(this);
    } catch (_) {
      return null;
    }
  }

  void safePop<T extends Object?>([T? result]) {
    final ctx = safe;
    if (ctx == null) return;
    final router = GoRouter.of(ctx);
    if (router.canPop()) router.pop<T>(result);
  }

  void safeGo(String location, {Object? extra}) {
    final ctx = safe;
    if (ctx == null) return;
    GoRouter.of(ctx).go(location, extra: extra);
  }

  Future<T?> safePush<T>(String location, {Object? extra}) async {
    final ctx = safe;
    if (ctx == null) return null;
    return GoRouter.of(ctx).push<T>(location, extra: extra);
  }

  void safeShowSnackBar(SnackBar snackBar) {
    safeScaffoldMessenger?.showSnackBar(snackBar);
  }

  ThemeData? get safeTheme {
    final ctx = safe;
    if (ctx == null) return null;
    try {
      return Theme.of(ctx);
    } catch (_) {
      return null;
    }
  }

  ScaffoldMessengerState? get safeScaffoldMessenger {
    final ctx = safe;
    if (ctx == null) return null;
    try {
      return ScaffoldMessenger.of(ctx);
    } catch (_) {
      return null;
    }
  }
}
