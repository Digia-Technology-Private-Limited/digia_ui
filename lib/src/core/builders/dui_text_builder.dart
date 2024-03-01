import 'package:digia_ui/src/components/DUIText/dui_text.dart';
import 'package:digia_ui/src/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUITextBuilder extends DUIWidgetBuilder {
  DUITextBuilder({required super.data});

  static DUITextBuilder? create(DUIWidgetJsonData data) {
    return DUITextBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIText(DUITextProps.fromJson(data.props));
  }
}
