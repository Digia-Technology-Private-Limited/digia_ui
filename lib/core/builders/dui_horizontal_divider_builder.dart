import 'package:digia_ui/components/horizontal_divider/dui_horizontal_divider.dart';
import 'package:digia_ui/components/horizontal_divider/dui_horizontal_divider_props.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIHorizontalDividerBuilder extends DUIWidgetBuilder {
  DUIHorizontalDividerBuilder({required super.data});

  static DUIHorizontalDividerBuilder? create(DUIWidgetJsonData data) {
    return DUIHorizontalDividerBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIHorizontalDivider(
        DUIHorizonatalDividerProps.fromJson(data.props));
  }
}
