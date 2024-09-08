import 'package:flutter/material.dart';

import '../../components/styled_vertical_divider/dui_styled_vertical_divider.dart';
import '../../components/styled_vertical_divider/dui_styled_vertical_divider_props.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIStyledVerticalDividerBuilder extends DUIWidgetBuilder {
  DUIStyledVerticalDividerBuilder({required super.data});

  static DUIStyledVerticalDividerBuilder? create(DUIWidgetJsonData data) {
    return DUIStyledVerticalDividerBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIStyledVerticalDivider(
        DUIStyledVerticalDividerProps.fromJson(data.props));
  }
}
