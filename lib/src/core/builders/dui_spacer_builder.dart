import 'package:flutter/material.dart';

import '../flutter_widgets.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

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
