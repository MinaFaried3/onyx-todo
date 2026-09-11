import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/responsive/widgets/flexible_wrap.dart';

class FlexWrap extends StatelessWidget {
  final List<Widget> children;

  final FlexibleMode mode;

  final double spacing;
  final double runSpacing;

  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final WrapAlignment wrapAlignment;
  final WrapCrossAlignment wrapCrossAlignment;

  final bool expandChildren; // like Expanded in Row

  const FlexWrap({
    super.key,
    required this.children,
    this.mode = FlexibleMode.adaptive,
    this.spacing = 8,
    this.runSpacing = 8,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapCrossAlignment = WrapCrossAlignment.center,
    this.expandChildren = false,
  });

  @override
  Widget build(BuildContext context) => switch (mode) {
    FlexibleMode.row     => _buildRow(),
    FlexibleMode.column  => _buildColumn(),
    FlexibleMode.wrap    => _buildWrap(),
    FlexibleMode.adaptive => LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        if (maxWidth < 600) return _buildWrap();
        return _buildRow();
      },
    ),
  };

  // =========================

  Widget _buildRow() {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _applySpacing(_applyExpand(children)),
    );
  }

  Widget _buildColumn() {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _applySpacing(_applyExpand(children), isRow: false),
    );
  }

  Widget _buildWrap() {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: wrapAlignment,
      crossAxisAlignment: wrapCrossAlignment,
      children: children,
    );
  }

  // =========================

  List<Widget> _applyExpand(List<Widget> list) {
    if (!expandChildren) return list;

    return list.map((e) => Expanded(child: e)).toList();
  }

  List<Widget> _applySpacing(List<Widget> list, {bool isRow = true}) {
    if (list.isEmpty) return list;

    final spaced = <Widget>[];

    for (int i = 0; i < list.length; i++) {
      spaced.add(list[i]);

      if (i != list.length - 1) {
        spaced.add(
          SizedBox(width: isRow ? spacing : 0, height: isRow ? 0 : spacing),
        );
      }
    }

    return spaced;
  }
}
