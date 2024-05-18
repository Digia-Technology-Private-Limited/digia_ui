import 'package:flutter/material.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../core/builders/dui_icon_builder.dart';
import 'bottom_nav_bar_item_props.dart';

class DUIBottomNavBarItem extends StatefulWidget {
  const DUIBottomNavBarItem(
      {required this.registry, Key? key, required this.itemProps})
      : super(key: key);
  final DUIWidgetRegistry registry;
  final DUIBottomNavigationBarItemProps itemProps;

  @override
  State<DUIBottomNavBarItem> createState() => _DUIBottomNavBarItemState();
}

class _DUIBottomNavBarItemState extends State<DUIBottomNavBarItem> {
  @override
  Widget build(BuildContext context) {
    final icon = DUIIconBuilder.fromProps(props: widget.itemProps.icon ?? {});
    final selectedIcon = DUIIconBuilder.fromProps(
        props: widget.itemProps.selectedIcon?['iconData'] == null
            ? widget.itemProps.icon
            : widget.itemProps.selectedIcon);

    return NavigationDestination(
      icon: icon.buildWithContainerProps(context),
      label: widget.itemProps.label ?? 'Label',
      selectedIcon: selectedIcon.buildWithContainerProps(context),
    );
  }
}
