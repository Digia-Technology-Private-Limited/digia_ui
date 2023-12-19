import 'package:digia_ui/components/dui_icons/dui_icon.dart';
import 'package:digia_ui/components/dui_icons/dui_icon_props.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIIconBuilder extends DUIWidgetBuilder {
  DUIIconBuilder({required super.data});

  static DUIIconBuilder? create(DUIWidgetJsonData data) {
    return DUIIconBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIIcon(DUIIconProps.fromJson(data.props));
  }
}