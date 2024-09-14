import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../components/dui_tab_view/dui_tab_bar.dart';
import '../../components/dui_tab_view/dui_tab_bar_props.dart';
import '../json_widget_builder.dart';

class DUITabBarBuilder extends DUIWidgetBuilder {
  DUITabBarBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUITabBarBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUITabBarBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }
    final tabViewWidget = DUITabBar(
      data: data,
      registry: registry,
      tabBarProps: DUITabBarProps.fromJson(data.props),
      varName: data.varName,
    );
    return tabViewWidget;
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for Tab view');
  }
}
