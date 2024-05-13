import 'package:flutter/material.dart';

import '../flutter_widgets.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

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
