import 'package:digia_ui/components/slider/dui_slider.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:flutter/material.dart';
import '../../components/slider/dui_slider_props.dart';
import '../page/props/dui_widget_json_data.dart';

class DUISliderBuilder extends DUIWidgetBuilder {
  DUISliderBuilder({required super.data});

  static DUISliderBuilder create(DUIWidgetJsonData data) {
    return DUISliderBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUISlider(DUISliderProps.fromJson(data.props));
  }
}
