import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../components/dui_tab_view/dui_tabView_item.dart';
import '../../components/dui_tab_view/dui_tabview_item_props.dart';
import '../json_widget_builder.dart';

class DUITabViewItem1Builder extends DUIWidgetBuilder {
  DUITabViewItem1Builder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUITabViewItem1Builder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUITabViewItem1Builder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }
    final tabViewWidget = DUITabViewItem1(
      data: data,
      registry: registry,
      duiTabView1Props: DUITabViewItem1Props.fromJson(data.props),
    );
    return tabViewWidget;
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for Tab view');
  }
}
