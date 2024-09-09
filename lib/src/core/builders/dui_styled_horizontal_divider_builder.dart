import 'package:flutter/material.dart';

import '../../components/styled_horizontal_divider/dui_styled_horizontal_divider.dart';
import '../../components/styled_horizontal_divider/dui_styled_horizontal_divider_props.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIStyledHorizontalDividerBuilder extends DUIWidgetBuilder {
  DUIStyledHorizontalDividerBuilder({required super.data});

  static DUIStyledHorizontalDividerBuilder? create(DUIWidgetJsonData data) {
    return DUIStyledHorizontalDividerBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIStyledHorizontalDivider(
        DUIStyledHorizonatalDividerProps.fromJson(data.props));
  }
}
