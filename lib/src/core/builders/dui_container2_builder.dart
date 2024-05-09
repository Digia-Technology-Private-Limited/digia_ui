import 'package:digia_ui/src/components/container/dui_container2_props.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:flutter/material.dart';
import '../../components/container/dui_container2.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIContainer2Builder extends DUIWidgetBuilder {
  DUIContainer2Builder({required super.data});

  static DUIContainer2Builder create(DUIWidgetJsonData data) {
    return DUIContainer2Builder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIContainer2(DUIContainer2Props.fromJson(data.props), data.children['child']?.first);
  }
}
