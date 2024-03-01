import 'package:digia_ui/src/components/dui_switch/dui_switch.dart';
import 'package:digia_ui/src/components/dui_switch/dui_switch_props.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUISwitchBuilder extends DUIWidgetBuilder {
  DUISwitchBuilder({required super.data});

  static DUISwitchBuilder? create(DUIWidgetJsonData data) {
    return DUISwitchBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUISwitch(DUISwitchProps.fromJson(data.props));
  }
}
