import 'package:flutter/material.dart';

import '../../Utils/dui_widget_registry.dart';
import '../../components/dui_listview.dart/dui_listview.dart';

import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIListViewBuilder extends DUIWidgetBuilder {
  DUIListViewBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUIListViewBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIListViewBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    return DuiListview(
      varName: data.varName,
      data: data,
      registry: registry,
    );
  }
}
