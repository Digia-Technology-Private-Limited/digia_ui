import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUICircularProgressBarBuilder extends DUIWidgetBuilder {
  DUICircularProgressBarBuilder({required super.data});

  static DUICircularProgressBarBuilder? create(DUIWidgetJsonData data) {
    return DUICircularProgressBarBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        makeColor(eval<String>(data.props['bgColor'], context: context));

    final indicatorColor =
        makeColor(eval<String>(data.props['indicatorColor'], context: context));

    final strokeWidth =
        eval<double>(data.props['strokeWidth'], context: context);

    final strokeAlign =
        eval<double>(data.props['stokeAlign'], context: context);

    final progressValue =
        eval<double>(data.props['progressValue'], context: context);

    return CircularProgressIndicator(
      value: progressValue == null ? null : progressValue / 100,
      backgroundColor: bgColor,
      color: indicatorColor,
      strokeWidth: strokeWidth ?? 4.0,
      strokeAlign: strokeAlign ?? CircularProgressIndicator.strokeAlignCenter,
      strokeCap: DUIDecoder.toStrokeCap(data.props['strokeCap']),
    );
  }
}
