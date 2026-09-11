

import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/widgets/animation/route/slide_page_route.dart';

class LeftSlidePageRoute extends SlidePageRoute {
  LeftSlidePageRoute(
      {required super.builder,
      super.duration,
      super.reverseDuration,
      super.curve,
      super.transitionColor,
      super.voiceLabel})
      : super(
          tweenOffset:
              Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero),
        );
}
