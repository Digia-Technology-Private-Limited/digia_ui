import 'package:flutter/material.dart';

import '../../Utils/util_functions.dart';
import '../../components/dui_switch/dui_switch.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUISwitchBuilder extends DUIWidgetBuilder {
  DUISwitchBuilder({required super.data});

  static DUISwitchBuilder? create(DUIWidgetJsonData data) {
    return DUISwitchBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUISwitch(
        varName: data.varName,
        enabled: true,
        value: eval<bool>(data.props['value'], context: context) ?? false,
        activeColor: makeColor(data.props['activeColor']),
        inactiveThumbColor: makeColor(data.props['inactiveThumbColor']),
        activeTrackColor: makeColor(data.props['activeTrackColor']),
        inactiveTrackColor: makeColor(data.props['inactiveTrackColor']));
  }
}
