import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/components/dui_tab_view/dui_tab_view_item.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:flutter/material.dart';

class DUITabViewItemBuilder extends DUIWidgetBuilder {
  DUITabViewItemBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUITabViewItemBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUITabViewItemBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }
    final tabViewItemWidget = DUITabViewItem(
      children: data.children['children']!,
      registry: registry!,
    );
    return tabViewItemWidget;
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for Tab View Item');
  }
}
