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
    final icon = DUIIconBuilder.fromProps(props: widget.itemProps.icon)
            ?.build(context) ??
        DUIIconBuilder.emptyIconWidget();
    final selectedIcon =
        DUIIconBuilder.fromProps(props: widget.itemProps.selectedIcon)
            ?.build(context);

    return NavigationDestination(
      icon: icon,
      label: widget.itemProps.label ?? 'Label',
      selectedIcon: selectedIcon ?? icon,
    );
  }
}
