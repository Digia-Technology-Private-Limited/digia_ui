import 'package:flutter/material.dart';

import '../../components/vertical_divider/dui_vertical_divider.dart';
import '../../components/vertical_divider/dui_vertical_divider_props.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIVerticalDividerBuilder extends DUIWidgetBuilder {
  DUIVerticalDividerBuilder({required super.data});

  static DUIVerticalDividerBuilder? create(DUIWidgetJsonData data) {
    return DUIVerticalDividerBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIVerticalDivider(DUIVerticalDividerProps.fromJson(data.props));
  }
}
