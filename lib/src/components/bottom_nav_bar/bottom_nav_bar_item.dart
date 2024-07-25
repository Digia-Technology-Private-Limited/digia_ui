import 'package:flutter/material.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/util_functions.dart';
import '../../core/builders/dui_icon_builder.dart';
import '../../core/evaluator.dart';
import '../DUIText/dui_text_style.dart';
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

    return Theme(
      data: ThemeData(
          navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.all(toTextStyle(
                  DUITextStyle.fromJson(
                      widget.itemProps.labelText?['textStyle']),
                  context)))),
      child: NavigationDestination(
        icon: icon,
        label: eval<String>(widget.itemProps.labelText?['text'],
                context: context) ??
            'Label',
        selectedIcon: selectedIcon ?? icon,
      ),
    );
  }
}
