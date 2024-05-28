import 'package:flutter/material.dart';

import '../../components/dui_switch/dui_switch.dart';
import '../../components/dui_switch/dui_switch_props.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

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
