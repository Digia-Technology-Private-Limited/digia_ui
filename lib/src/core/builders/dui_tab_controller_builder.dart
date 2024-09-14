import 'package:flutter/material.dart';

import '../../Utils/dui_widget_registry.dart';
import '../../components/dui_tab_view/dui_tab_controller.dart';
import '../../components/dui_tab_view/dui_tab_controller_props.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUITabControllerBuilder extends DUIWidgetBuilder {
  DUITabControllerBuilder({required super.data});

  static DUITabControllerBuilder create(DUIWidgetJsonData data) {
    return DUITabControllerBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUITabController(
      registry: DUIWidgetRegistry.shared,
      child: data.children['child']?.first,
      tabControllerProps: DuiTabControllerProps.fromJson(data.props),
    );
  }
}
