import 'package:flutter/material.dart';
import 'customTabBar.dart';

class IndicatorTabBar extends CustomTabBar {
  final Color indicatorColor;
  final Color dividerColor;
  final TabBarIndicatorSize indicatorSize;
  final double dividerHeight;

  IndicatorTabBar({
    required super.controller,
    required super.tabs,
    required super.iconPosition,
    super.labelColor = Colors.blue,
    super.unselectedLabelColor = Colors.grey,
    super.unselectedLabelStyle = const TextStyle(),
    super.labelStyle = const TextStyle(),
    this.indicatorColor = Colors.blue,
    this.dividerColor = Colors.transparent,
    this.dividerHeight = 0.0,
    super.isScrollable = false,
    this.indicatorSize = TabBarIndicatorSize.tab,
    required super.alignment,
    super.labelPadding = EdgeInsets.zero,
    super.tabBarPadding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return isScrollable
        ? Align(
            alignment: alignment,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: TabBar(
                controller: controller,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: labelColor,
                unselectedLabelColor: unselectedLabelColor,
                indicatorSize: indicatorSize,
                labelPadding: labelPadding,
                padding: tabBarPadding,
                unselectedLabelStyle: unselectedLabelStyle,
                labelStyle: labelStyle,
                indicatorColor: indicatorColor,
                dividerColor: dividerColor,
                dividerHeight: dividerHeight,
                tabs: List.generate(tabs.length, (index) {
                  bool isSelected = controller.index == index;
                  return _buildTabContent(tabs[index], isSelected);
                }),
              ),
            ),
          )
        : TabBar(
            controller: controller,
            isScrollable: false,
            labelColor: labelColor,
            unselectedLabelColor: unselectedLabelColor,
            indicatorSize: indicatorSize,
            labelPadding: labelPadding,
            padding: tabBarPadding,
            unselectedLabelStyle: unselectedLabelStyle,
            labelStyle: labelStyle,
            indicatorColor: indicatorColor,
            dividerColor: dividerColor,
            dividerHeight: dividerHeight,
            tabs: List.generate(tabs.length, (index) {
              bool isSelected = controller.index == index;
              return _buildTabContent(tabs[index], isSelected);
            }),
          );
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [text, icon],
        );
      case IconPosition.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [icon, text],
        );
      case IconPosition.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [text, icon],
        );
      case IconPosition.top:
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [icon, text],
        );
    }
  }
}
