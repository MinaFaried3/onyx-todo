import 'package:onyx_todo/core/onyx_todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:onyx_todo/core/network/error/app_failures.dart';

AppFormController useAppFormController() {
  final controller = useMemoized(AppFormController.new);
  useEffect(() => controller.dispose, [controller]);
  return controller;
}


class AppFormController {
  final GlobalKey<FormBuilderState> key = GlobalKey<FormBuilderState>();

  FormBuilderState? get _state => key.currentState;

  // ── Focus Management ─────────────────────────────────────────────────────────

  void requestFocus(String fieldId) {
    _state?.fields[fieldId]?.effectiveFocusNode.requestFocus();
  }


  void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  
  void focusNext(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }


  void focusPrevious(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }


  void focusFirstError() {
    final state = _state;
    if (state == null) return;

    for (final entry in state.fields.entries) {
      if (entry.value.hasError) {
        requestFocus(entry.key);
        break;
      }
    }
  }


  bool validateAndFocusFirstError() {
    final isValid = validate();
    if (!isValid) {
      focusFirstError();
    }
    return isValid;
  }

 
  bool submit(void Function(Json values) onSuccess) {
    if (validateAndFocusFirstError()) {
      onSuccess(getValues());
      return true;
    }
    return false;
  }

  // ── Validation ───────────────────────────────────────────────────────

  bool validate() => _state?.saveAndValidate() ?? false;


  // ── Values ───────────────────────────────────────────────────────────────────

  Map<String, dynamic> getValues() {
    _state?.save();
    return _state?.value ?? const {};
  }


  T? getValue<T>(String fieldId) {
    _state?.save();
    final value = _state?.value[fieldId];
    return value is T ? value : null;
  }

  void setValue(String fieldId, dynamic value) {
    _state?.fields[fieldId]?.didChange(value);
  }

  // ── Errors ───────────────────────────────────────────────────────────────────


  String? getFieldError(String fieldId) =>
      _state?.fields[fieldId]?.errorText;

  void setFieldError(String fieldId, String? errorMessage) {
    final field = _state?.fields[fieldId];
    if (errorMessage != null && errorMessage.isNotEmpty) {
      field?.invalidate(errorMessage);
    } else {
      field?.clearError();
    }
  }

  void clearFieldError(String fieldId) {
    _state?.fields[fieldId]?.clearError();
  }

  void clearAllErrors() {
    _state?.fields.values.forEach((f) => f.clearError());
  }

  // ── Backend errors ────────────────────────────────────────────────────────────

  void setBackendErrors(Map<String, Object?> errors, {bool focusFirst = true}) {
    final state = _state;
    if (state == null) return;

    for (final entry in errors.entries) {
      final msg = switch (entry.value) {
        final List list when list.isNotEmpty => list.first.toString(),
        final String s when s.isNotEmpty => s,
        _ => null,
      };
      if (msg != null) state.fields[entry.key]?.invalidate(msg);
    }

    if (focusFirst) {
      focusFirstError();
    }
  }

  void handleFailure(Failure? failure, {bool focusFirst = true}) {
    final errors = failure?.appErrors?.errors;
    if (errors != null && errors.isNotEmpty) {
      setBackendErrors(errors, focusFirst: focusFirst);
    }
  }

  // ── Reset & Lifecycle ─────────────────────────────────────────────────────────

  void reset() => _state?.reset();

  // ignore: empty_catches
  void dispose() {}
}
