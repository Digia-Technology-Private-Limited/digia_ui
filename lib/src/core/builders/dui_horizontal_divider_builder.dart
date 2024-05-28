import 'package:flutter/material.dart';

import '../../components/horizontal_divider/dui_horizontal_divider.dart';
import '../../components/horizontal_divider/dui_horizontal_divider_props.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIHorizontalDividerBuilder extends DUIWidgetBuilder {
  DUIHorizontalDividerBuilder({required super.data});

  static DUIHorizontalDividerBuilder? create(DUIWidgetJsonData data) {
    return DUIHorizontalDividerBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIHorizontalDivider(
        DUIHorizonatalDividerProps.fromJson(data.props));
  }
}
