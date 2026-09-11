

import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/widgets/animation/route/size_page_route.dart';

class HorizontalSizePageRoute extends SizePageRoute {
  HorizontalSizePageRoute({
    required super.builder,
    super.duration,
    super.reverseDuration,
    super.transitionColor,
    super.voiceLabel,
    super.alignment,
    super.curve,
  }) : super(
          axis: Axis.horizontal,
        );
}
