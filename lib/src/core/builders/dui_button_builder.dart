import 'package:digia_ui/src/components/button/button.dart';
import 'package:digia_ui/src/components/button/button.props.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIButtonBuilder extends DUIWidgetBuilder {
  DUIButtonBuilder({required super.data});

  static DUIButtonBuilder create(DUIWidgetJsonData data) {
    return DUIButtonBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIButton(DUIButtonProps.fromJson(data.props));
  }
}
