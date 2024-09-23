import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../Utils/util_functions.dart';
import '../base/virtual_leaf_stateless_widget.dart';
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
    final progressValue = payload.eval<double>(props.get('progressValue'));
    final isReverse = payload.eval<bool>(props.get('isReverse')) ?? false;
    final String type = props.getString('type') ?? 'indeterminate';

    return RotatedBox(
      quarterTurns: isReverse ? 2 : 0,
      child: _getChild(progressValue, type, payload),
    );
  }

  Widget _getChild(double? progressValue, String? type, RenderPayload payload) {
    if (type == 'indeterminate') {
      return SizedBox(
        width: props.getDouble('width'),
        child: LinearProgressIndicator(
          color: makeColor(payload.eval(props.get('indicatorColor'))) ??
              Colors.blue,
          backgroundColor: makeColor(payload.eval(props.get('bgColor'))) ??
              Colors.transparent,
          minHeight: props.getDouble('thickness'),
          borderRadius: BorderRadius.circular(
            props.getDouble('borderRadius') ?? 0.0,
          ),
        ),
      );
    } else {
      return LinearPercentIndicator(
        barRadius: Radius.circular(
          props.getDouble('borderRadius') ?? 0.0,
        ),
        width: props.getDouble('width'),
        lineHeight: props.getDouble('thickness') ?? 5.0,
        percent: progressValue != null ? progressValue / 100.0 : 0,
        animation: true,
        backgroundColor:
            makeColor(payload.eval(props.get('bgColor'))) ?? Colors.transparent,
        progressColor:
            makeColor(payload.eval(props.get('indicatorColor'))) ?? Colors.blue,
        padding: EdgeInsets.zero,
      );
    }
  }
}
