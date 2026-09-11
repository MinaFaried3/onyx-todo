

import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/widgets/animation/route/slide_page_route.dart';

class BottomSlidePageRoute extends SlidePageRoute {
  BottomSlidePageRoute(
      {required super.builder,
      super.duration,
      super.reverseDuration,
      super.curve,
      super.transitionColor,
      super.voiceLabel})
      : super(
          tweenOffset:
              Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero),
        );
}
