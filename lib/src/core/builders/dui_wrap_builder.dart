import 'package:digia_ui/src/components/dui_wrap/dui_wrap.dart';
import 'package:digia_ui/src/components/dui_wrap/dui_wrap_props.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';

class DUIWrapBuilder extends DUIWidgetBuilder {
  DUIWrapBuilder({required super.data});

  static DUIWrapBuilder create(DUIWidgetJsonData data) {
    return DUIWrapBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIWrap(
      children: data.children['children'],
      props: DUIWrapProps.fromJson(data.props),
    );
  }
}
