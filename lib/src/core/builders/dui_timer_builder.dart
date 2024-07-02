import 'package:flutter/material.dart';
import '../../components/dui_timer/dui_timer.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUITimerBuilder extends DUIWidgetBuilder {
  DUITimerBuilder({required super.data});

  static DUITimerBuilder? create(DUIWidgetJsonData data) {
    return DUITimerBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUITimer(
        varName: data.varName,
        props: data.props,
        child: data.children['child']?.firstOrNull);
  }
}
