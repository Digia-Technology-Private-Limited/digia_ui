import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../digia_ui.dart';
import 'buttonTabBar.dart';
import 'indicatorTabBar.dart';

enum TabBarMode { indicator, button, toggleButton }

enum IconPosition { left, right, top, bottom }

abstract class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final IconPosition iconPosition;
  final List<TabItem> tabs;
  final Alignment alignment;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle labelStyle;
  final TextStyle? unselectedLabelStyle;
  final EdgeInsetsGeometry labelPadding;
  final EdgeInsetsGeometry tabBarPadding;
  final bool isScrollable;

  CustomTabBar({
    required this.controller,
    this.iconPosition = IconPosition.top,
    required this.tabs,
    this.alignment = Alignment.centerLeft,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle = const TextStyle(),
    this.labelPadding = const EdgeInsets.all(0),
    this.tabBarPadding = const EdgeInsets.all(0),
    this.unselectedLabelStyle = null,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context);
}

class TabBarBuilder extends CustomTabBar {
  final TabBarMode tabBarType;

  // Specific properties for ButtonTabBar
  final Color? buttonActiveBgColor;
  final Color? buttonInactiveBgColor;
  final Color? buttonBorderColor;
  final Color? buttonIdleBorderColor;
  final double? buttonBorderWidth;
  final double? buttonRadius;
  final double? buttonElevation;
  final EdgeInsetsGeometry? buttonMargin;

  // Specific properties for IndicatorTabBar
  final Color? indicatorColor;
  final Color? dividerColor;
  final TabBarIndicatorSize? indicatorSize;
  final double? dividerHeight;

  TabBarBuilder({
    required this.tabBarType,
    this.buttonActiveBgColor,
    this.buttonInactiveBgColor,
    this.buttonBorderColor,
    this.buttonIdleBorderColor,
    this.buttonBorderWidth,
    this.buttonRadius,
    this.buttonElevation,
    this.buttonMargin,
    this.indicatorColor,
    this.dividerColor,
    this.indicatorSize,
    this.dividerHeight,
    required super.controller,
    super.iconPosition,
    required super.tabs,
    super.alignment,
    super.isScrollable,
    super.labelColor,
    super.labelPadding,
    super.labelStyle,
    super.tabBarPadding,
    super.unselectedLabelColor,
    super.unselectedLabelStyle,
  });

  @override
  Widget build(BuildContext context) {
    switch (tabBarType) {
      case TabBarMode.button:
        return ButtonTabBar(
          controller: controller,
          tabs: tabs,
          iconPosition: iconPosition,
          alignment: alignment,
          activeBgColor: buttonActiveBgColor ?? Colors.blue,
          inactiveBgColor: buttonInactiveBgColor ?? Colors.grey,
          borderColor: buttonBorderColor ?? Colors.blue,
          idleBorderColor: buttonIdleBorderColor ?? Colors.grey,
          borderWidth: buttonBorderWidth ?? 2.0,
          radius: buttonRadius ?? 8.0,
          elevation: buttonElevation ?? 5.0,
          margin: buttonMargin ?? EdgeInsets.all(0),
          isScrollable: isScrollable ?? false,
          labelPadding: labelPadding,
          tabBarPadding: tabBarPadding,
          labelColor: labelColor ?? Colors.white,
          unselectedLabelColor: unselectedLabelColor,
          labelStyle: labelStyle,
          unselectedLabelStyle: unselectedLabelStyle,
        );

      case TabBarMode.indicator:
        return IndicatorTabBar(
          controller: controller,
          tabs: tabs,
          iconPosition: iconPosition,
          alignment: alignment,
          indicatorColor: indicatorColor ?? Colors.blue,
          dividerColor: dividerColor ?? Colors.transparent,
          indicatorSize: indicatorSize ?? TabBarIndicatorSize.tab,
          dividerHeight: dividerHeight ?? 0.0,
          isScrollable: isScrollable ?? false,
          labelPadding: labelPadding ?? EdgeInsets.all(0),
          tabBarPadding: tabBarPadding ?? EdgeInsets.all(0),
          labelColor: labelColor ?? Colors.blue,
          unselectedLabelColor: unselectedLabelColor,
          labelStyle: labelStyle,
          unselectedLabelStyle: unselectedLabelStyle,
        );

      default:
        throw UnimplementedError('TabBarType not implemented');
    }
  }
}

class TabItem {
  final Widget icon;
  final String text;
  // final Alignment iconPosition;
  // final bool isIconColorByState;
  // final Color selectedLabelColor;
  // final Color unselectedLabelColor;

  TabItem({
    required this.icon,
    required this.text,
    // this.iconPosition = Alignment.topCenter,
    // this.isIconColorByState = true,
    // this.selectedLabelColor = Colors.blue,
    // this.unselectedLabelColor = Colors.grey,
  });
}
