import 'package:flutter/material.dart';
import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../components/bottom_nav_bar/bottom_nav_bar_item.dart';
import '../../components/bottom_nav_bar/bottom_nav_bar_item_props.dart';
import '../json_widget_builder.dart';

class DUIBottomNavigationBarItemBuilder extends DUIWidgetBuilder {
  DUIBottomNavigationBarItemBuilder(
      DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUIBottomNavigationBarItemBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIBottomNavigationBarItemBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }
    final navBarItemWidget = DUIBottomNavBarItem(
      registry: registry!,
      itemProps: DUIBottomNavigationBarItemProps.fromJson(data.props),
    );
    return navBarItemWidget;
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for Bottom Navigation Bar Item');
  }
}
