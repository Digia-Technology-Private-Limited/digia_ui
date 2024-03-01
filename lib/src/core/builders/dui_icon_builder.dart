import 'package:flutter/material.dart';

import '../../components/dui_icons/dui_icon.dart';
import '../../components/dui_icons/dui_icon_props.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIIconBuilder extends DUIWidgetBuilder {
  DUIIconBuilder({required super.data});

  static DUIIconBuilder? create(DUIWidgetJsonData data) {
    return DUIIconBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIIcon(DUIIconProps.fromJson(data.props));
  }
}
