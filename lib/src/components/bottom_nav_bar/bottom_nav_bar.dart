import 'package:flutter/material.dart';
import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import 'bottom_nav_bar_props.dart';

class DUIBottomNavigationBar extends StatefulWidget {
  final List<DUIWidgetJsonData> children;
  final DUIWidgetRegistry? registry;
  final DUIBottomNavigationBarProps barProps;
  final Function(int)? onDestinationSelected;

  const DUIBottomNavigationBar(
      {super.key,
      required this.children,
      this.registry,
      required this.barProps,
      this.onDestinationSelected});

  @override
  State<DUIBottomNavigationBar> createState() => _DUIBottomNavigationBarState();
}

class _DUIBottomNavigationBarState extends State<DUIBottomNavigationBar> {
  int _selectedIndex = 0;

  void _handleDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (widget.onDestinationSelected != null) {
      widget.onDestinationSelected!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      animationDuration: Duration(
          milliseconds:
              int.tryParse(widget.barProps.duration?.toString() ?? '0') ?? 0),
      shadowColor: widget.barProps.shadowColor?.letIfTrue(toColor),
      elevation: widget.barProps.elevation,
      height: widget.barProps.height,
      indicatorColor: widget.barProps.indicatorColor?.letIfTrue(toColor),
      indicatorShape: widget.barProps.borderShape == null
          ? null
          : toButtonShape(widget.barProps.borderShape),
      labelBehavior: widget.barProps.showLabels.isNullEmptyOrFalse
          ? NavigationDestinationLabelBehavior.alwaysHide
          : NavigationDestinationLabelBehavior.alwaysShow,
      backgroundColor: widget.barProps.backgroundColor?.letIfTrue(toColor),
      selectedIndex: _selectedIndex,
      destinations: widget.children.map((e) => DUIWidget(data: e)).toList(),
      onDestinationSelected: _handleDestinationSelected,
    );
  }
}
