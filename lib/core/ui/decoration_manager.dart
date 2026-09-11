
import 'package:flutter/material.dart';
import 'package:onyx_todo/core/ui/color_manager.dart';

class DecorationManager {
  static BoxDecoration whiteRoundedBox = BoxDecoration(
    color: ColorsManager.white,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration mintRoundedBox = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: ColorsManager.lightMintGreenBgColor,
  );
}
