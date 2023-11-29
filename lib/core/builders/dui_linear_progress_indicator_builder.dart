import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/components/linear_progress_bar/linear_progress.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

import '../../components/linear_progress_bar/linear_progress_props.dart';

class DUILinearProgressIndicatorBuilder extends DUIWidgetBuilder {
  DUILinearProgressIndicatorBuilder({required super.data});

  static DUILinearProgressIndicatorBuilder? create(DUIWidgetJsonData data) {
    return DUILinearProgressIndicatorBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUILinearProgress(DUILinearProgressProps.fromJson(data.props));
  }
}
