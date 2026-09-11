import 'package:flutter/material.dart';

// ============================================================
// ENUMS
// ============================================================

enum FlexibleMode {
  row,
  column,
  wrap,

  /// Automatically switches between wrap → row → row based on
  /// available constraints from [LayoutBuilder].
  adaptive,
}

enum FlexibleChildFit {
  /// Child takes its natural (intrinsic) size.
  loose,

  /// Child expands to fill the available main-axis space equally.
  /// Only applies in [FlexibleMode.row] and [FlexibleMode.column].
  expanded,

  /// Child fills all remaining space after siblings are laid out.
  /// Equivalent to a single [Expanded] with flex:1.
  fill,
}

// ============================================================
// PER-CHILD CONFIGURATION
// ============================================================

/// Wrap any child with this to override its layout behavior individually.
///
/// ```dart
/// FlexibleChild(
///   fit: FlexibleChildFit.expanded,
///   flex: 2,
///   alignment: .centerRight,
///   child: TextField(),
/// )
/// ```
class FlexibleChild extends StatelessWidget {
  final Widget child;
  final FlexibleChildFit fit;
  final int flex;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final BoxConstraints? constraints;

  const FlexibleChild({
    super.key,
    required this.child,
    this.fit = FlexibleChildFit.loose,
    this.flex = 1,
    this.alignment,
    this.padding,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) => child;
}



/// A unified layout widget that merges [Row], [Column], and [Wrap]
/// with overflow safety, per-child control, and adaptive mode.
///
/// Handles:
/// - All [Row]/[Column] alignments
/// - All [Wrap] alignments
/// - Overflow — never throws
/// - Per-child [FlexibleChild] fit, flex, padding, constraints
/// - Adaptive breakpoint switching via [LayoutBuilder]
/// - RTL-aware spacing via [TextDirection]
/// - Decoration + padding on the container
/// - Divider support between children
///
/// ```dart
/// FlexibleWrap(
///   mode: FlexibleMode.adaptive,
///   spacing: 12,
///   children: [
///     FlexibleChild(fit: FlexibleChildFit.expanded, child: TextField()),
///     ElevatedButton(onPressed: () {}, child: Text('Submit')),
///   ],
/// )
/// ```
class FlexibleWrap extends StatelessWidget {
  // --------------------------------------------------
  // Core
  // --------------------------------------------------
  final List<Widget> children;
  final FlexibleMode mode;

  // --------------------------------------------------
  // Spacing
  // --------------------------------------------------
  final double spacing;
  final double runSpacing;

  // --------------------------------------------------
  // Row / Column alignment
  // --------------------------------------------------
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;

  // --------------------------------------------------
  // Wrap alignment (used in wrap + adaptive→wrap)
  // --------------------------------------------------
  final WrapAlignment wrapAlignment;
  final WrapAlignment wrapRunAlignment;
  final WrapCrossAlignment wrapCrossAlignment;

  // --------------------------------------------------
  // Global child fit (overridden per-child by FlexibleChild)
  // --------------------------------------------------
  final FlexibleChildFit childFit;

  // --------------------------------------------------
  // Adaptive breakpoints
  // --------------------------------------------------
  final double compactBreakpoint; // below → wrap
  final double mediumBreakpoint; // below → row, above → row

  // --------------------------------------------------
  // Container decoration
  // --------------------------------------------------
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final Clip clipBehavior;

  // --------------------------------------------------
  // Divider between children (Row/Column only)
  // --------------------------------------------------
  final Widget? divider;

  // --------------------------------------------------
  // Directionality
  // --------------------------------------------------
  final TextDirection? textDirection;

  const FlexibleWrap({
    super.key,
    required this.children,
    this.mode = FlexibleMode.adaptive,
    this.spacing = 8,
    this.runSpacing = 8,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapRunAlignment = WrapAlignment.start,
    this.wrapCrossAlignment = WrapCrossAlignment.center,
    this.childFit = FlexibleChildFit.loose,
    this.compactBreakpoint = 600,
    this.mediumBreakpoint = 1000,
    this.padding,
    this.decoration,
    this.clipBehavior = Clip.none,
    this.divider,
    this.textDirection,
  });

  // ── Convenience: explicit row ──────────────────────────────
  const FlexibleWrap.row({
    super.key,
    required this.children,
    this.spacing = 8,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.childFit = FlexibleChildFit.loose,
    this.padding,
    this.decoration,
    this.clipBehavior = Clip.none,
    this.divider,
    this.textDirection,
  }) : mode = FlexibleMode.row,
       runSpacing = 0,
       wrapAlignment = WrapAlignment.start,
       wrapRunAlignment = WrapAlignment.start,
       wrapCrossAlignment = WrapCrossAlignment.center,
       compactBreakpoint = 600,
       mediumBreakpoint = 1000;

  // ── Convenience: explicit column ──────────────────────────
  const FlexibleWrap.column({
    super.key,
    required this.children,
    this.spacing = 8,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.childFit = FlexibleChildFit.loose,
    this.padding,
    this.decoration,
    this.clipBehavior = Clip.none,
    this.divider,
    this.textDirection,
  }) : mode = FlexibleMode.column,
       runSpacing = 0,
       wrapAlignment = WrapAlignment.start,
       wrapRunAlignment = WrapAlignment.start,
       wrapCrossAlignment = WrapCrossAlignment.center,
       compactBreakpoint = 600,
       mediumBreakpoint = 1000;

  // ── Convenience: explicit wrap ────────────────────────────
  const FlexibleWrap.wrap({
    super.key,
    required this.children,
    this.spacing = 8,
    this.runSpacing = 8,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapRunAlignment = WrapAlignment.start,
    this.wrapCrossAlignment = WrapCrossAlignment.center,
    this.padding,
    this.decoration,
    this.clipBehavior = Clip.none,
    this.textDirection,
  }) : mode = FlexibleMode.wrap,
       mainAxisAlignment = MainAxisAlignment.start,
       crossAxisAlignment = CrossAxisAlignment.center,
       mainAxisSize = MainAxisSize.max,
       verticalDirection = VerticalDirection.down,
       textBaseline = null,
       childFit = FlexibleChildFit.loose,
       compactBreakpoint = 600,
       mediumBreakpoint = 1000,
       divider = null;

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    Widget layout;

    if (mode == FlexibleMode.adaptive) {
      layout = LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          // Unbounded (e.g. inside a horizontal scroll) → always wrap
          if (w == double.infinity || w < compactBreakpoint) {
            return _buildWrap(context);
          }
          return _buildRow(context);
        },
      );
    } else {
      layout = switch (mode) {
        FlexibleMode.row => _buildRow(context),
        FlexibleMode.column => _buildColumn(context),
        FlexibleMode.wrap => _buildWrap(context),
        FlexibleMode.adaptive => _buildWrap(context), // unreachable
      };
    }

    return _wrapContainer(layout);
  }

  // ============================================================
  // BUILDERS
  // ============================================================

  Widget _buildRow(BuildContext context) {
    final processed = _processChildren(children, isRow: true, context: context);
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      textDirection: textDirection ?? Directionality.maybeOf(context),
      children: _applySpacing(processed, isRow: true),
    );
  }

  Widget _buildColumn(BuildContext context) {
    final processed = _processChildren(
      children,
      isRow: false,
      context: context,
    );
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: _applySpacing(processed, isRow: false),
    );
  }

  Widget _buildWrap(BuildContext context) {
    // In wrap mode, FlexibleChild.fit is ignored (Wrap manages its own layout)
    // We still respect padding and alignment overrides via Align.
    final processed = children.map((child) {
      if (child is FlexibleChild) {
        Widget c = child.child;
        if (child.padding != null) {
          c = Padding(padding: child.padding!, child: c);
        }
        if (child.constraints != null) {
          c = ConstrainedBox(constraints: child.constraints!, child: c);
        }
        if (child.alignment != null) {
          c = Align(alignment: child.alignment!, child: c);
        }
        return c;
      }
      return child;
    }).toList();

    return Wrap(
      direction: Axis.horizontal,
      alignment: wrapAlignment,
      runAlignment: wrapRunAlignment,
      crossAxisAlignment: wrapCrossAlignment,
      spacing: spacing,
      runSpacing: runSpacing,
      textDirection: textDirection ?? Directionality.maybeOf(context),
      verticalDirection: verticalDirection,
      children: processed,
    );
  }

  // ============================================================
  // CHILD PROCESSING — handles FlexibleChild per-item config
  // ============================================================

  List<Widget> _processChildren(
    List<Widget> list, {
    required bool isRow,
    required BuildContext context,
  }) {
    return list.map((child) {
      if (child is FlexibleChild) {
        return _resolveFlexibleChild(child, isRow: isRow);
      }
      // Apply global childFit to plain widgets
      return _applyFit(child, fit: childFit, flex: 1, isRow: isRow);
    }).toList();
  }

  Widget _resolveFlexibleChild(FlexibleChild item, {required bool isRow}) {
    Widget child = item.child;

    // Apply constraints
    if (item.constraints != null) {
      child = ConstrainedBox(constraints: item.constraints!, child: child);
    }

    // Apply padding
    if (item.padding != null) {
      child = Padding(padding: item.padding!, child: child);
    }

    // Apply alignment
    if (item.alignment != null) {
      child = Align(alignment: item.alignment!, child: child);
    }

    return _applyFit(child, fit: item.fit, flex: item.flex, isRow: isRow);
  }

  Widget _applyFit(
    Widget child, {
    required FlexibleChildFit fit,
    required int flex,
    required bool isRow,
  }) =>
      switch (fit) {
        FlexibleChildFit.loose   => child,
        FlexibleChildFit.expanded => Expanded(flex: flex, child: child),
        FlexibleChildFit.fill    => Flexible(flex: flex, fit: FlexFit.tight, child: child),
      };

  // ============================================================
  // SPACING — inserts SizedBox or custom divider between children
  // ============================================================

  List<Widget> _applySpacing(List<Widget> list, {required bool isRow}) {
    if (list.isEmpty) return list;
    if (spacing == 0 && divider == null) return list;

    final result = <Widget>[];
    for (int i = 0; i < list.length; i++) {
      result.add(list[i]);
      if (i < list.length - 1) {
        if (divider != null) {
          result.add(divider!);
        } else {
          result.add(
            SizedBox(width: isRow ? spacing : 0, height: isRow ? 0 : spacing),
          );
        }
      }
    }
    return result;
  }

  // ============================================================
  // CONTAINER — optional decoration + padding wrapper
  // ============================================================

  Widget _wrapContainer(Widget child) {
    if (padding == null && decoration == null) return child;

    Widget result = child;

    if (padding != null) {
      result = Padding(padding: padding!, child: result);
    }

    if (decoration != null) {
      result = DecoratedBox(decoration: decoration!, child: result);
    }

    if (clipBehavior != Clip.none) {
      result = ClipRect(clipBehavior: clipBehavior, child: result);
    }

    return result;
  }
}
