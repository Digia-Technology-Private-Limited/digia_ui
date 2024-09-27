import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../components/dui_tab_view/dui_tab_view_content.dart';
import '../../components/dui_tab_view/dui_tab_view_content_props.dart';
import '../json_widget_builder.dart';

class DUITabViewContentBuilder extends DUIWidgetBuilder {
  DUITabViewContentBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUITabViewContentBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUITabViewContentBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }
    final tabViewWidget = DUITabViewContent(
      data: data,
      registry: registry,
      duiTabView1Props: DUITabViewContentProps.fromJson(data.props),
    );
    return tabViewWidget;
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for Tab view');
  }
}
