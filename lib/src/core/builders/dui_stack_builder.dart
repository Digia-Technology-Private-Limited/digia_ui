import 'package:digia_ui/src/components/dui_stack/dui_stack.dart';
import 'package:digia_ui/src/components/dui_stack/dui_stack_props.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';

class DUIStackBuilder extends DUIWidgetBuilder {
  DUIStackBuilder({required super.data});

  static DUIStackBuilder create(DUIWidgetJsonData data) {
    return DUIStackBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIStack(
        props:DUIStackProps.fromJson(data.props), children:  data.children['children']);
  }
}
