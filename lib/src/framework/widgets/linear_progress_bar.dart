import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/util_functions.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';

class VWLinearProgressBar extends VirtualLeafStatelessWidget {
  VWLinearProgressBar({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final progressValue = payload.eval<double>(props['progressValue']);
    final isReverse = payload.eval<bool>(props['isReverse']) ?? false;
    final String? type = props['type'] ?? 'indeterminate';

    return RotatedBox(
      quarterTurns: isReverse ? 2 : 0,
      child: _getChild(progressValue, type, payload),
    );
  }

  Widget _getChild(double? progressValue, String? type, RenderPayload payload) {
    if (type == 'indeterminate') {
      return SizedBox(
        width: NumDecoder.toDouble(props['width']),
        child: LinearProgressIndicator(
          color:
              makeColor(payload.eval(props['indicatorColor'])) ?? Colors.blue,
          backgroundColor:
              makeColor(payload.eval(props['bgColor'])) ?? Colors.transparent,
          minHeight: NumDecoder.toDouble(props['thickness']),
          borderRadius: BorderRadius.circular(
            NumDecoder.toDouble(props['borderRadius']) ?? 0.0,
          ),
        ),
      );
    } else {
      return LinearPercentIndicator(
        barRadius: Radius.circular(
          NumDecoder.toDouble(props['borderRadius']) ?? 0.0,
        ),
        width: NumDecoder.toDouble(props['width']),
        lineHeight: NumDecoder.toDouble(props['thickness']) ?? 5.0,
        percent: progressValue != null ? progressValue / 100.0 : 0,
        animation: true,
        backgroundColor:
            makeColor(payload.eval(props['bgColor'])) ?? Colors.transparent,
        progressColor:
            makeColor(payload.eval(props['indicatorColor'])) ?? Colors.blue,
        padding: EdgeInsets.zero,
      );
    }
  }
}
