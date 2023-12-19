import 'package:digia_ui/components/circular_progress_indicator/dui_circular_progress_indicator.dart';
import 'package:digia_ui/components/circular_progress_indicator/dui_circular_progress_indicator_props.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';


class DUICircularProgressIndicatorBuilder extends DUIWidgetBuilder {
  DUICircularProgressIndicatorBuilder({required super.data});

  static DUICircularProgressIndicatorBuilder? create(DUIWidgetJsonData data) {
    return DUICircularProgressIndicatorBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUICircularProgressIndicator(
        DUICircularProgressIndicatorProps.fromJson(data.props));
  }
}
