import 'package:flutter/widgets.dart';

import '../../components/dui_pin_field/dui_pin_field.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIPinFieldBuilder extends DUIWidgetBuilder {
  DUIPinFieldBuilder({required super.data});

  static DUIPinFieldBuilder create(DUIWidgetJsonData data) {
    return DUIPinFieldBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIPinField(
      varName: data.varName,
      props: data.props,
    );
  }
}
