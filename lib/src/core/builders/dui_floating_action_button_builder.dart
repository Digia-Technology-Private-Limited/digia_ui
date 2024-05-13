import 'package:flutter/material.dart';

import '../../components/floating_action_button/floating_action_button.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIFloatingActionButtonBuilder extends DUIWidgetBuilder {
  DUIFloatingActionButtonBuilder({required super.data});

  static DUIFloatingActionButtonBuilder? create(DUIWidgetJsonData data) {
    return DUIFloatingActionButtonBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIFloatingActionButton.floatingActionButton(
        data.props, context, data);
  }
}
