import 'package:flutter/material.dart';

import 'customTabBar.dart';

class ButtonTabBar extends CustomTabBar {
  final Color activeBgColor;
  final Color inactiveBgColor;
  final Color borderColor;
  final Color idleBorderColor;
  final double borderWidth;
  final double radius;
  final double elevation;
  final EdgeInsetsGeometry margin;
  final bool isScrollable;
  final Color toggleBorderColor;
  final double toggleBorderRadius;
  final Color toggleBgColor;
  final double toggleBorderWidth;
  // final bool isIconTakesState;

  ButtonTabBar({
    // this.isIconTakesState=false,
    this.activeBgColor = Colors.blue,
    this.inactiveBgColor = Colors.grey,
    this.borderColor = Colors.blue,
    this.idleBorderColor = Colors.grey,
    this.borderWidth = 2.0,
    this.radius = 8.0,
    this.elevation = 5,
    this.margin = const EdgeInsets.all(0),
    this.isScrollable = false,
    this.toggleBgColor = const Color.fromARGB(255, 130, 206, 239),
    this.toggleBorderRadius = 14,
    this.toggleBorderColor = Colors.grey,
    this.toggleBorderWidth = 2,
    required super.controller,
    required super.iconPosition,
    required super.tabs,
    super.alignment = Alignment.center,
    super.labelColor = Colors.blue,
    super.labelPadding,
    super.tabBarPadding,
    super.unselectedLabelColor = Colors.green,
    super.labelStyle,
    super.unselectedLabelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return isScrollable
        ? Container(
            margin: tabBarPadding,
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(toggleBorderRadius),
            //     color: toggleBgColor,
            //     border: Border.all(
            //         color: toggleBorderColor, width: toggleBorderWidth)),
            child: Align(
              alignment: alignment,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    return Padding(
                      padding: margin,
                      child: _buildTabButton(index),
                    );
                  }),
                ),
              ),
            ),
          )
        : Container(
            margin: tabBarPadding,
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(toggleBorderRadius),
            //     color: toggleBgColor,
            //     border: Border.all(
            //         color: toggleBorderColor, width: toggleBorderWidth)),
            child: Row(
              children: List.generate(tabs.length, (index) {
                return Expanded(
                  child: Padding(
                    padding: margin,
                    child: _buildTabButton(index),
                  ),
                );
              }),
            ),
          );
  }

  Widget _buildTabButton(int index) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final isSelected = controller.index == index;
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? activeBgColor : inactiveBgColor,
              foregroundColor: isSelected ? labelColor : unselectedLabelColor,
              textStyle: isSelected
                  ? labelStyle.copyWith(color: labelColor)
                  : unselectedLabelStyle?.copyWith(
                          color: unselectedLabelColor) ??
                      labelStyle,
              side: (borderWidth > 0)
                  ? BorderSide(
                      color: isSelected ? borderColor : idleBorderColor,
                      width: borderWidth,
                    )
                  : null,
              elevation: elevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
            onPressed: () {
              controller.animateTo(index);
            },
            child: _buildTabContent(tabs[index], isSelected),
          );
        });
  }

  Widget _buildTabContent(TabItem tabItem, bool isSelected) {
    // final Color selectedColor = labelColor ?? labelStyle?.color ?? Colors.blue;
    // final Color unselectedColor =
    //     unselectedLabelColor ?? unselectedLabelStyle?.color ?? Colors.grey;

    // final Widget icon = (isIconColorByState)
    //     ? ColorFiltered(
    //         colorFilter: ColorFilter.mode(
    //             isSelected ? selectedColor : unselectedColor, BlendMode.srcIn),
    //         child: tabItem.icon,
    //       )
    final Widget icon = tabItem.icon;

    final Text text = Text(
      tabItem.text,
      // style: isSelected
      //     ? labelStyle?.copyWith(color: selectedColor)
      //     : unselectedLabelStyle?.copyWith(color: unselectedColor) ??
      //         labelStyle?.copyWith(color: unselectedColor),
    );

    switch (iconPosition) {
      case IconPosition.bottom:
        return Padding(
          padding: labelPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [text, icon],
          ),
        );
      case IconPosition.left:
        return Padding(
          padding: labelPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [icon, text],
          ),
        );
      case IconPosition.right:
        return Padding(
          padding: labelPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [text, icon],
          ),
        );
      case IconPosition.top:
      default:
        return Padding(
          padding: labelPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [icon, text],
          ),
        );
    }
  }
}
