import 'package:digia_ui/components/progress_bar/linear/linear_progress_bar.dart';
import 'package:digia_ui/components/progress_bar/linear/linear_progress_bar_props.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUILinearProgressIndicatorBuilder extends DUIWidgetBuilder {
  DUILinearProgressIndicatorBuilder({required super.data});

  static DUILinearProgressIndicatorBuilder? create(DUIWidgetJsonData data) {
    return DUILinearProgressIndicatorBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUILinearProgressBar(DUILinearProgressBarProps.fromJson(data.props));
  }
}
