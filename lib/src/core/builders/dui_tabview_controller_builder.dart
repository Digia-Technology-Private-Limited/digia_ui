import 'package:flutter/material.dart';

import '../../Utils/dui_widget_registry.dart';
import '../../components/dui_tab_view/dui_tab_view_controller_props.dart';
import '../../components/dui_tab_view/dui_tabview_controller.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUITabViewControllerBuilder extends DUIWidgetBuilder {
  DUITabViewControllerBuilder({required super.data});

  static DUITabViewControllerBuilder create(DUIWidgetJsonData data) {
    return DUITabViewControllerBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUITabViewController(
      registry: DUIWidgetRegistry.shared,
      child: data.children['child']?.first,
      tabViewControllerProps: DuiTabViewControllerProps.fromJson(data.props),
    );
  }
}
