import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/util_functions.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUILinearProgressBarBuilder extends DUIWidgetBuilder {
  DUILinearProgressBarBuilder({required super.data});

  static DUILinearProgressBarBuilder? create(DUIWidgetJsonData data) {
    return DUILinearProgressBarBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final progressValue =
        eval<double>(data.props['progressValue'], context: context);
    final isReverse =
        eval<bool>(data.props['isReverse'], context: context) ?? false;
    final String? type = data.props['type'] ?? 'indeterminate';

    return RotatedBox(
        quarterTurns: isReverse ? 2 : 0, child: _getChild(progressValue, type));
  }

  Widget _getChild(double? progressValue, String? type) {
    if (type == 'indeterminate') {
      return SizedBox(
        width: NumDecoder.toDouble(data.props['width']),
        child: LinearProgressIndicator(
          color: makeColor(data.props['indicatorColor']) ?? Colors.blue,
          backgroundColor:
              makeColor(data.props['bgColor']) ?? Colors.transparent,
          minHeight: NumDecoder.toDouble(data.props['thickness']),
          borderRadius: BorderRadius.circular(
            NumDecoder.toDouble(data.props['borderRadius']) ?? 0.0,
          ),
        ),
      );
    } else {
      return LinearPercentIndicator(
        barRadius: Radius.circular(
          NumDecoder.toDouble(data.props['borderRadius']) ?? 0.0,
        ),
        width: NumDecoder.toDouble(data.props['width']),
        lineHeight: NumDecoder.toDouble(data.props['thickness']) ?? 5.0,
        percent: progressValue != null ? progressValue / 100.0 : 0,
        animation: NumDecoder.toBool(data.props['animation']) ?? false,
        animateFromLastPercent:
            NumDecoder.toBool(data.props['animateFromLastPercent']) ?? false,
        backgroundColor: makeColor(data.props['bgColor']) ?? Colors.transparent,
        progressColor: makeColor(data.props['indicatorColor']) ?? Colors.blue,
        padding: EdgeInsets.zero,
      );
    }
  }
}
