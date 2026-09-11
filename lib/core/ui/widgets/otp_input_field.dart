// ─────────────────────────────────────────────────────────────────────────────
// OtpInputField — self-contained, reusable OTP widget
//
// Usage (minimal — fully responsive by default):
//   OtpInputField(onCompleted: (v) => verify(v))
//
// Usage (custom theme colors):
//   OtpInputField(
//     length: 6,
//     theme: OtpTheme.underline(focusColor: Colors.green),
//     onCompleted: (v) => verify(v),
//   )
//
// Usage (fully custom cell widget):
//   OtpInputField(
//     theme: OtpTheme.custom(boxBuilder: (ctx, cell) => MyBox(cell)),
//   )
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onyx_todo/core/ui/responsive/responsive_extension.dart';

// ─── Cell state ───────────────────────────────────────────────────────────────

/// Snapshot of a single OTP cell — passed to [OtpTheme.custom].
class OtpCellState {
  /// The character at this position; empty string if not yet entered.
  final String char;

  /// Whether this cell is the currently active (cursor) cell.
  final bool isFocused;

  /// Whether the field is in a validation-error state.
  final bool hasError;

  /// Whether the cell already has a character entered.
  final bool isFilled;

  /// 0-based position of this cell.
  final int index;

  const OtpCellState({
    required this.char,
    required this.isFocused,
    required this.hasError,
    required this.isFilled,
    required this.index,
  });
}

// ─── Box variant ─────────────────────────────────────────────────────────────

enum OtpBoxVariant {
  /// Bottom border only + subtle drop-shadow.
  underline,

  /// Full rounded border on all sides.
  outlined,

  /// Fully custom — driven by [OtpTheme.boxBuilder].
  custom,
}

// ─── Theme ────────────────────────────────────────────────────────────────────

/// Visual configuration for [OtpInputField].
///
/// All sizing fields are **optional** — when omitted the widget picks
/// responsive values automatically using the project's [ResponsiveExtension]:
///
/// | field    | mobile | tablet | desktop |
/// |----------|--------|--------|---------|
/// | boxSize  | 56     | 64     | 72      |
/// | fontSize | 20     | 24     | 28      |
class OtpTheme {
  /// Which built-in cell style to use, or [OtpBoxVariant.custom] for [boxBuilder].
  final OtpBoxVariant variant;

  /// Override the cell box size.
  /// Leave `null` to use the automatic responsive value.
  final double? boxSize;

  /// Override the character font size.
  /// Leave `null` to use `context.sp(responsiveSize)`.
  final double? fontSize;

  /// Full [TextStyle] override. When set, [fontSize] is ignored.
  final TextStyle? textStyle;

  /// Cell border / underline color when idle.
  final Color idleColor;

  /// Cell border / underline color when focused.
  final Color focusColor;

  /// Cell border / underline color on validation error.
  final Color errorColor;

  /// Cell background color.
  final Color backgroundColor;

  /// Completely replaces the built-in cell widget.
  /// Required when [variant] is [OtpBoxVariant.custom].
  final Widget Function(BuildContext context, OtpCellState cell)? boxBuilder;

  // ── underline ─────────────────────────────────────────────────────────────

  /// Bottom border only + subtle drop-shadow.
  const OtpTheme.underline({
    this.boxSize,
    this.fontSize,
    this.textStyle,
    this.idleColor = const Color(0xFFD6D6D6),
    this.focusColor = const Color(0xFF578FFF),
    this.errorColor = const Color(0xFFFE8383),
    this.backgroundColor = Colors.white,
  })  : variant = OtpBoxVariant.underline,
        boxBuilder = null;

  // ── outlined ──────────────────────────────────────────────────────────────

  /// Full rounded border on all sides.
  const OtpTheme.outlined({
    this.boxSize,
    this.fontSize,
    this.textStyle,
    this.idleColor = const Color(0xFFD6D6D6),
    this.focusColor = const Color(0xFF578FFF),
    this.errorColor = const Color(0xFFFE8383),
    this.backgroundColor = Colors.white,
  })  : variant = OtpBoxVariant.outlined,
        boxBuilder = null;

  // ── custom ────────────────────────────────────────────────────────────────

  /// Supply your own cell widget via [boxBuilder].
  const OtpTheme.custom({
    required Widget Function(BuildContext, OtpCellState) this.boxBuilder,
    this.boxSize,
    this.fontSize,
    this.textStyle,
    this.idleColor = const Color(0xFFD6D6D6),
    this.focusColor = const Color(0xFF578FFF),
    this.errorColor = const Color(0xFFFE8383),
    this.backgroundColor = Colors.white,
  }) : variant = OtpBoxVariant.custom;
}

// ─── Widget ───────────────────────────────────────────────────────────────────

/// A fully customisable OTP / PIN input field that integrates with [Form].
///
/// Renders [length] visual cells backed by a single hidden [TextField] that
/// captures real keyboard / autofill input — including SMS OTP autofill on
/// Android and iOS.
class OtpInputField extends FormField<String> {
  /// Number of OTP digits. Defaults to `4`.
  final int length;

  /// External controller. When omitted, an internal one is created.
  final TextEditingController? controller;

  /// Called on every character change.
  final ValueChanged<String>? onChanged;

  /// Called when the user has filled all [length] digits.
  final ValueChanged<String>? onCompleted;

  /// Keyboard type shown to the user. Defaults to [TextInputType.number].
  final TextInputType keyboardType;

  /// External focus node. When omitted, an internal one is created.
  final FocusNode? focusNode;

  /// Replaces each character with `●` when `true`.
  final bool obscureText;

  /// Controls cell appearance. Defaults to [OtpTheme.underline].
  final OtpTheme theme;

  OtpInputField({
    super.key,
    this.length = 4,
    this.controller,
    this.onChanged,
    this.onCompleted,
    this.keyboardType = TextInputType.number,
    this.focusNode,
    this.obscureText = false,
    this.theme = const OtpTheme.underline(),
    super.enabled = true,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.autovalidateMode = AutovalidateMode.disabled,
  }) : super(
          builder: (state) => (state as _OtpInputFieldState)._build(),
        );

  @override
  FormFieldState<String> createState() => _OtpInputFieldState();
}

// ─── State ────────────────────────────────────────────────────────────────────

class _OtpInputFieldState extends FormFieldState<String> {
  late final TextEditingController _ctrl;
  late final FocusNode _focus;
  bool _focused = false;

  @override
  OtpInputField get widget => super.widget as OtpInputField;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ??
        TextEditingController(text: widget.initialValue ?? '');
    _focus = widget.focusNode ?? FocusNode();
    _ctrl.addListener(_onText);
    _focus.addListener(_onFocus);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onText);
    _focus.removeListener(_onFocus);
    if (widget.controller == null) _ctrl.dispose();
    if (widget.focusNode == null) _focus.dispose();
    super.dispose();
  }

  void _onText() {
    final text = _ctrl.text;
    if (value == text) return;
    didChange(text);
    widget.onChanged?.call(text);
    if (text.length == widget.length) widget.onCompleted?.call(text);
  }

  void _onFocus() => setState(() => _focused = _focus.hasFocus);

  // ── responsive helpers ────────────────────────────────────────────────────

  /// Box size: theme override → responsive (mobile 56 / tablet 64 / desktop 72)
  double _boxSize(BuildContext ctx) =>
      widget.theme.boxSize ??
      ctx.responsiveValue<double>(mobile: 56, tablet: 64, desktop: 72);

  /// Font size: theme override → responsive scaled with [ctx.sp]
  double _fontSize(BuildContext ctx) =>
      widget.theme.fontSize ??
      ctx.sp(ctx.responsiveValue<double>(mobile: 20, tablet: 24, desktop: 28));

  /// Border radius: responsive (mobile 16 / tablet 20 / desktop 24)
  double _borderRadius(BuildContext ctx) =>
      ctx.responsiveValue<double>(mobile: 16, tablet: 20, desktop: 24);

  // ── build ──────────────────────────────────────────────────────────────────

  Widget _build() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Hidden real TextField — handles input, autofill, keyboard
              Positioned.fill(
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _ctrl,
                    focusNode: _focus,
                    keyboardType: widget.keyboardType,
                    obscureText: widget.obscureText,
                    enabled: widget.enabled,
                    maxLength: widget.length,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    inputFormatters: widget.keyboardType == TextInputType.number
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : null,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              // Visual cells
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.enabled
                    ? () {
                        if (!_focus.hasFocus) _focus.requestFocus();
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0; i < widget.length; i++) _buildCell(i),
                  ],
                ),
              ),
            ],
          ),
          if (hasError && errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                errorText!,
                style: TextStyle(
                  fontSize: context.sp(12),
                  color: widget.theme.errorColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCell(int index) {
    final text = _ctrl.text;
    final isFocused = _focused && text.length == index;
    final isFilled = text.length > index;
    final char = isFilled ? (widget.obscureText ? '●' : text[index]) : '';

    final cellState = OtpCellState(
      char: char,
      isFocused: isFocused,
      hasError: hasError,
      isFilled: isFilled,
      index: index,
    );

    final double boxSize = _boxSize(context);
    final double fontSize = _fontSize(context);

    // custom builder — full control
    if (widget.theme.variant == OtpBoxVariant.custom) {
      return SizedBox(
        width: boxSize,
        height: boxSize,
        child: widget.theme.boxBuilder!(context, cellState),
      );
    }

    final activeColor = switch ((hasError, isFocused)) {
      (true, _) => widget.theme.errorColor,
      (_, true) => widget.theme.focusColor,
      _ => widget.theme.idleColor,
    };

    final decoration = switch (widget.theme.variant) {
      OtpBoxVariant.outlined => BoxDecoration(
          color: widget.theme.backgroundColor,
          borderRadius: BorderRadius.circular(_borderRadius(context)),
          border: Border.all(
            color: activeColor,
            width: isFocused ? 2.0 : 1.0,
          ),
        ),
      _ => BoxDecoration(
          color: widget.theme.backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: activeColor,
              width: isFocused ? 2.0 : 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: activeColor.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
    };

    final textStyle = widget.theme.textStyle ??
        TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: widget.theme.focusColor,
        );

    return Container(
      width: boxSize,
      height: boxSize,
      alignment: Alignment.center,
      decoration: decoration,
      child: Text(char, style: textStyle),
    );
  }
}
