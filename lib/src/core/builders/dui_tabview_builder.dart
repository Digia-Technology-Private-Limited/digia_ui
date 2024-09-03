import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../components/dui_tab_view/dui_tabview1.dart';
import '../../components/dui_tab_view/dui_tabview_props.dart';
import '../json_widget_builder.dart';

class DUITabView1Builder extends DUIWidgetBuilder {
  DUITabView1Builder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUITabView1Builder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUITabView1Builder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }
    final tabViewWidget = DUITabView1(
      data: data,
      registry: registry,
      tabViewProps: DUITabView1Props.fromJson(data.props),
      varName: data.varName,
    );
    return tabViewWidget;
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for Tab view');
  }
}
