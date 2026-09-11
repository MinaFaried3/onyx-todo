
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onyx_todo/core/helper/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:onyx_todo/core/ui/color_manager.dart';

part 'bottom_nav_bar_item.dart';
class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({
    super.key,
    required this.onChangePage,
    required this.items,
    this.selectedItemColor = ColorsManager.offWhite,
    this.unSelectedItemColor = ColorsManager.redPrimary22,
    this.initSelectedIndex = 0,
  });

  final Function(int) onChangePage;
  final Color selectedItemColor;
  final Color unSelectedItemColor;
  final List<BottomNavBarItem> items;
  final int initSelectedIndex;

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  late int _currentPage;
  final Duration animationDuration = DurationManager.m250;
  final Duration fadeAnimationDuration = DurationManager.m500;
  final double bottomNavBarHeight = 60;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: bottomNavBarHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: buildNavBarDecoration(),
              child: Row(
                textDirection: .ltr,
                children: buildNavItemsList(),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> buildNavItemsList() {
    return widget.items.map(
      (bottomNavBarItem) {
        int indexOfCurrentItem = widget.items.indexOf(bottomNavBarItem);
        bool isCurrentItemSelected = _currentPage == indexOfCurrentItem;

        return Flexible(
            child: GestureDetector(
          onTap: () => itemOnPressed(bottomNavBarItem),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return AnimatedContainer(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              duration: animationDuration,
              decoration: buildLightEffectDecoration(isCurrentItemSelected),
              child: Center(
                child: buildNavItem(bottomNavBarItem, isCurrentItemSelected),
              ),
            );
          }),
        ));
      },
    ).toList();
  }

  Widget buildNavItem(
      BottomNavBarItem bottomNavBarItem, bool isCurrentItemSelected) {
    return AnimatedCrossFade(
      firstChild: buildIconItem(
        bottomNavBarItem: bottomNavBarItem,
        color: widget.unSelectedItemColor,
        isSelected: isCurrentItemSelected,
      ),
      secondChild: buildIconItem(
        bottomNavBarItem: bottomNavBarItem,
        color: widget.selectedItemColor,
        isSelected: isCurrentItemSelected,
      ),
      crossFadeState: (_currentPage == widget.items.indexOf(bottomNavBarItem))
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: fadeAnimationDuration,
    );
  }

  BoxDecoration buildLightEffectDecoration(bool isCurrentItemSelected) {
    return BoxDecoration(
      border: isCurrentItemSelected
          ? const Border(
              top: BorderSide(
                width: 2.5,
                color: ColorsManager.offWhite400,
              ),
            )
          : null,
      gradient: isCurrentItemSelected
          ? LinearGradient(
              colors: [
                ColorsManager.offWhite600.withOpacity(0.4),
                ColorsManager.offWhite700.withOpacity(0.01),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
          : null,
    );
  }

  void itemOnPressed(BottomNavBarItem bottomNavBarItem) {
    setState(() {
      _currentPage = widget.items.indexOf(bottomNavBarItem);
    });
    bottomNavBarItem.onPressed?.call();
    widget.onChangePage.call(_currentPage);
  }

  BoxDecoration buildNavBarDecoration() {
    return BoxDecoration(
      color: ColorsManager.redPrimaryAA,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: ColorsManager.offWhite800,
        width: 1,
      ),
    );
  }

  SvgPicture buildIconItem({
    required BottomNavBarItem bottomNavBarItem,
    required Color color,
    required bool isSelected,
  }) {
    return SvgPicture.asset(bottomNavBarItem.iconPath,
        matchTextDirection: true,
        height: isSelected ? 30 : 25,
        colorFilter: ColorFilter.mode(
          color,
          BlendMode.srcIn,
        ));
  }
}
