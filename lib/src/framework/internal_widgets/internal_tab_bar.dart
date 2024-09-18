import 'package:flutter/material.dart';

class InternalTabBar extends StatefulWidget {
  final TabController controller;
  final TabBarIndicatorSize tabBarIndicatorSize;
  final bool isScrollable;
  final TabAlignment? tabAlignment;
  final Color? dividerColor;
  final Color? indicatorColor;
  final double? indicatorWeight;
  final double? dividerHeight;
  final EdgeInsetsGeometry? tabBarPadding;
  final EdgeInsetsGeometry? labelPadding;
  final Widget Function(BuildContext context, int index) selectedWidgetBuilder;
  final Widget Function(BuildContext context, int index)?
      unselectedWidgetBuilder;

  const InternalTabBar({
    super.key,
    required this.controller,
    required this.selectedWidgetBuilder,
    this.tabBarIndicatorSize = TabBarIndicatorSize.tab,
    this.isScrollable = false,
    this.tabAlignment,
    this.unselectedWidgetBuilder,
    this.dividerColor,
    this.indicatorColor,
    this.indicatorWeight,
    this.dividerHeight,
    this.tabBarPadding,
    this.labelPadding,
  });

  @override
  _InternalTabBarState createState() => _InternalTabBarState();
}

class _InternalTabBarState extends State<InternalTabBar> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return TabBar(
      controller: widget.controller,
      isScrollable: widget.isScrollable,
      tabAlignment: widget.tabAlignment,
      indicatorSize: widget.tabBarIndicatorSize,
      dividerColor: widget.dividerColor,
      indicatorColor: widget.indicatorColor,
      indicatorWeight: widget.indicatorWeight ?? 2.0,
      dividerHeight: widget.dividerHeight,
      padding: widget.tabBarPadding,
      labelPadding: widget.labelPadding,
      tabs: List.generate(controller.length, (index) {
        if (widget.unselectedWidgetBuilder == null) {
          return widget.selectedWidgetBuilder(context, index);
        }

        return AnimatedBuilder(
          animation: controller.animation!,
          builder: (context, child) {
            final isSelected = controller.index == index;
            return isSelected
                ? widget.selectedWidgetBuilder(context, index)
                : widget.unselectedWidgetBuilder!(context, index);
          },
        );
      }),
    );
  }
}
