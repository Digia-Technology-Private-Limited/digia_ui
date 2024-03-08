import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/components/dui_expandable/dui_expandable.dart';
import 'package:digia_ui/src/components/dui_expandable/dui_expandable_props.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';

class DUIExpandableBuilder extends DUIWidgetBuilder {
  DUIExpandableBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUIExpandableBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIExpandableBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    return DUIExpandable(
      props: DUIExpandableProps.fromJson(data.props),
      registry: registry,
    );
  }
}
