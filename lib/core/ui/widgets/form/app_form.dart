import 'package:onyx_todo/core/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:onyx_todo/core/ui/widgets/form/app_form_controller.dart';


class _AppFormScope extends InheritedWidget {
  final AppFormController controller;

  const _AppFormScope({
    required this.controller,
    required super.child,
  });

  // The controller is memoized and never replaced — propagation only, no rebuilds.
  @override
  bool updateShouldNotify(covariant _AppFormScope oldWidget) => false;
}

extension FormContextExtension on BuildContext {
  AppFormController get form => AppForm.of(this);
  AppFormController? get maybeForm => AppForm.maybeOf(this);
}

class AppForm extends StatelessWidget {
  final AppFormController controller;
  final Widget child;
  final Json initialValue;
  final AutovalidateMode? autovalidateMode;
  final VoidCallback? onChanged;
  final bool enabled;

  const AppForm({
    super.key,
    required this.controller,
    required this.child,
    this.initialValue = const <String, dynamic>{},
    this.autovalidateMode,
    this.onChanged,
    this.enabled = true,
  });

  static AppFormController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_AppFormScope>()?.controller;
  }

  static AppFormController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(controller != null, 'No AppForm ancestor found in context');
    return controller!;
  }

  @override
  Widget build(BuildContext context) {
    return _AppFormScope(
      controller: controller,
      child: FormBuilder(
        key: controller.key,
        initialValue: initialValue,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        enabled: enabled,
        child: child,
      ),
    );
  }
}
