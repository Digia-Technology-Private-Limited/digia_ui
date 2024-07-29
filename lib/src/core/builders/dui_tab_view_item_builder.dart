import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../components/dui_tab_view/dui_tab_view_item.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';

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
      visibleChildren: data.children['children']!
          .where((child) => eval<bool>(child.props['visibility'], context: context) ?? true)
          .toList(),
      registry: registry!,
    );
    return tabViewItemWidget;
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for Tab View Item');
  }
}
