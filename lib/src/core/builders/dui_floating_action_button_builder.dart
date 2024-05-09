import 'package:digia_ui/src/components/floating_action_button/floating_action_button.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIFloatingActionButtonBuilder extends DUIWidgetBuilder {
  DUIFloatingActionButtonBuilder({required super.data});

  static DUIFloatingActionButtonBuilder? create(DUIWidgetJsonData data) {
    return DUIFloatingActionButtonBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIFloatingActionButton.floatingActionButton(data.props, context, data);
  }
}
