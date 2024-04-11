import 'package:digia_ui/src/components/dui_icon_button/dui_icon_button.dart';
import 'package:digia_ui/src/components/dui_icon_button/dui_icon_button_props.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIIconButtonBuilder extends DUIWidgetBuilder {
  DUIIconButtonBuilder({required super.data});

  static DUIIconButtonBuilder create(DUIWidgetJsonData data) {
    return DUIIconButtonBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIIconButton(
      props: DUIIconButtonProps.fromJson(data.props),
    );
  }
}
