
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onyx_todo/core/extension/context_extensions.dart';
import 'package:onyx_todo/core/ui/color_manager.dart';
import 'package:onyx_todo/core/ui/styles_manager.dart';
import 'package:onyx_todo/core/ui/theme_manager.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final VoidCallback? onBackButtonPressed;
  final bool hasParentStack;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final Color? backgroundColor;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.onBackButtonPressed,
    this.systemOverlayStyle,
    this.backgroundColor = ColorsManager.whiteRedBgColor,
    this.hasParentStack = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      systemOverlayStyle:
          systemOverlayStyle ?? ThemeManger.whiteRedStatusBarStyle,
      surfaceTintColor: ColorsManager.white,
      actions: actions,
      leading: hasParentStack
          ? BackButton(
              color: ColorsManager.darkTextColor,
              onPressed: onBackButtonPressed ?? () => context.safePop(),
            )
          : SizedBox(),
      title: Text(title, style: get500MediumStyle(fontSize: 18)),
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppBarNoHeight extends StatelessWidget implements PreferredSizeWidget {
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool automaticallyImplyLeading;

  const AppBarNoHeight(
      {super.key,
      this.systemOverlayStyle,
      this.automaticallyImplyLeading = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: systemOverlayStyle ?? ThemeManger.whiteStatusBarStyle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      primary: false,
      toolbarHeight: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(0);
}
