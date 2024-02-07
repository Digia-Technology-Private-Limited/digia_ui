import 'package:digia_ui/components/progress_bar/circular/circular_progress_bar.dart';
import 'package:digia_ui/components/progress_bar/circular/circular_progress_bar_props.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUICircularProgressBarBuilder extends DUIWidgetBuilder {
  DUICircularProgressBarBuilder({required super.data});

  static DUICircularProgressBarBuilder? create(DUIWidgetJsonData data) {
    return DUICircularProgressBarBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUICircularProgressBar(
        DUICircularProgressBarProps.fromJson(data.props));
  }
}
