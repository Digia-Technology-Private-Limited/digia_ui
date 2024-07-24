import 'package:flutter/material.dart';

import '../../components/dui_stepper/dui_stepper.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIStepperBuilder extends DUIWidgetBuilder {
  DUIStepperBuilder({required super.data});

  static DUIStepperBuilder? create(DUIWidgetJsonData data) {
    return DUIStepperBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIStepper(
        varName: data.varName,
        props: data.props,
        children: data.children['children']);
  }
}
