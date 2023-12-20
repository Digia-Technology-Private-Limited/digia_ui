import 'package:digia_ui/components/vertical_divider/dui_vertical_divider.dart';
import 'package:digia_ui/components/vertical_divider/dui_vertical_divider_props.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIVerticalDividerBuilder extends DUIWidgetBuilder {
  DUIVerticalDividerBuilder({required super.data});

  static DUIVerticalDividerBuilder? create(DUIWidgetJsonData data) {
    return DUIVerticalDividerBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIVerticalDivider(DUIVerticalDividerProps.fromJson(data.props));
  }
}
