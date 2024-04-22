import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/components/dui_tab_view/dui_tab_view.dart';

import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:flutter/material.dart';

class DUITabViewBuilder extends DUIWidgetBuilder {
  DUITabViewBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUITabViewBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUITabViewBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }
    final tabViewWidget = DUITabView(
      children: data.children['children']!,
      registry: registry,
    );
    return tabViewWidget;
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for Tab view');
  }
}
