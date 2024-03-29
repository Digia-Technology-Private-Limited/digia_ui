import 'package:digia_ui/src/core/flutter_widgets.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUISizedBoxBuilder extends DUIWidgetBuilder {
  DUISizedBoxBuilder({required super.data});

  static DUISizedBoxBuilder create(DUIWidgetJsonData data) {
    return DUISizedBoxBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return FW.sizedBox(data.props);
  }
}
