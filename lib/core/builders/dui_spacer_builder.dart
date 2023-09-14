import 'package:digia_ui/core/flutter_widgets.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUISpacerBuilder extends DUIWidgetBuilder {
  DUISpacerBuilder({required super.data});

  static DUISpacerBuilder create(DUIWidgetJsonData data) {
    return DUISpacerBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return FW.spacer(data.props);
  }
}
