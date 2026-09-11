import 'package:flutter/material.dart';

class WidgetLifeCycle extends StatefulWidget {
  const WidgetLifeCycle({
    super.key,
    this.child,
    this.builder,
    this.onInit,
    this.onDispose,
    this.onDeactivate,
    this.onDidChangeDependencies,
    this.onDidUpdateWidget,
  }) : assert(
         child != null || builder != null,
         'Either child or builder must be provided',
       );

  final Widget? child;
  final WidgetBuilder? builder;
  final void Function(BuildContext context)? onInit;
  final void Function(BuildContext context)? onDispose;
  final void Function(BuildContext context)? onDeactivate;
  final void Function(BuildContext context)? onDidChangeDependencies;
  final void Function(BuildContext context, WidgetLifeCycle oldWidget)? onDidUpdateWidget;

  @override
  State<WidgetLifeCycle> createState() => _WidgetLifeCycleState();
}

class _WidgetLifeCycleState extends State<WidgetLifeCycle> {
  @override
  void initState() {
    super.initState();
    widget.onInit?.call(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onDidChangeDependencies?.call(context);
  }

  @override
  void didUpdateWidget(WidgetLifeCycle oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.onDidUpdateWidget?.call(context, oldWidget);
  }

  @override
  void deactivate() {
    widget.onDeactivate?.call(context);
    super.deactivate();
  }

  @override
  void dispose() {
    widget.onDispose?.call(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final builder = widget.builder;
    if (builder != null) {
      return builder(context);
    }
    return widget.child!;
  }
}
