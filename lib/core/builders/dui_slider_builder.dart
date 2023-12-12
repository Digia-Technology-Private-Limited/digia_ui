import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/components/dui_slider/dui_slider.dart';
import 'package:digia_ui/components/dui_slider/dui_slider_props.dart';
import 'package:digia_ui/components/html_view/dui_html_view.dart';
import 'package:digia_ui/components/html_view/dui_htmview_props.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUISliderBuilder extends DUIWidgetBuilder {
  DUISliderBuilder({required super.data});

  static DUISliderBuilder? create(DUIWidgetJsonData data) {
    return DUISliderBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUISlider(
      DUISliderProps.fromJson(data.props),
      onChanged: (val) {},
    );
  }
}
