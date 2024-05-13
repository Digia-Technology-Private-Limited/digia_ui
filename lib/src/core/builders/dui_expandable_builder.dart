import 'package:flutter/material.dart';

import '../../Utils/dui_widget_registry.dart';
import '../../components/dui_expandable/dui_expandable.dart';
import '../../components/dui_expandable/dui_expandable_props.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

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
      children: data.children,
      props: DUIExpandableProps.fromJson(data.props),
      registry: registry,
    );
  }
}
