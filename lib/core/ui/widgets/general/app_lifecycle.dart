import 'package:flutter/material.dart';

typedef AppLifeCycleCallback =
    void Function(BuildContext context, AppLifecycleState state);

class AppLifeCycle extends StatefulWidget {
  const AppLifeCycle({
    super.key,
    this.child,
    this.builder,
    this.onResumed,
    this.onInactive,
    this.onPaused,
    this.onDetached,
    this.onHidden,
    this.onStateChanged,
  }) : assert(
          child != null || builder != null,
          'Either child or builder must be provided',
        );

  final Widget? child;
  final Widget Function(BuildContext context, AppLifecycleState state)? builder;
  final AppLifeCycleCallback? onResumed;
  final AppLifeCycleCallback? onInactive;
  final AppLifeCycleCallback? onPaused;
  final AppLifeCycleCallback? onDetached;
  final AppLifeCycleCallback? onHidden;
  final ValueChanged<AppLifecycleState>? onStateChanged;

  @override
  State<AppLifeCycle> createState() => _AppLifeCycleState();
}

class _AppLifeCycleState extends State<AppLifeCycle>
    with WidgetsBindingObserver {
  late AppLifecycleState _currentState;

  @override
  void initState() {
    super.initState();
    _currentState =
        WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    if (_currentState == state) return;

    setState(() {
      _currentState = state;
    });

    widget.onStateChanged?.call(state);

    switch (state) {
      case AppLifecycleState.resumed:
        widget.onResumed?.call(context, state);
      case AppLifecycleState.inactive:
        widget.onInactive?.call(context, state);
      case AppLifecycleState.paused:
        widget.onPaused?.call(context, state);
      case AppLifecycleState.detached:
        widget.onDetached?.call(context, state);
      case AppLifecycleState.hidden:
        widget.onHidden?.call(context, state);
    }
  }

  @override
  Widget build(BuildContext context) {
    final builder = widget.builder;
    if (builder != null) {
      return builder(context, _currentState);
    }
    return widget.child!;
  }
}
