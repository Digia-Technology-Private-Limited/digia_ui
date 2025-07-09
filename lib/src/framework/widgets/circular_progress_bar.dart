import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWCircularProgressBar extends VirtualLeafStatelessWidget<Props> {
  VWCircularProgressBar({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final progressValue = payload.eval<double>(props.get('progressValue'));
    final String type = props.getString('type') ?? 'indeterminate';

    return _getChild(progressValue, type, payload);
  }

  Widget _getChild(double? progressValue, String? type, RenderPayload payload) {
    if (type == 'indeterminate') {
      return SizedBox(
        width: props.getDouble('size'),
        height: props.getDouble('size'),
        child: CircularProgressIndicator(
          color: payload.evalColor(props.get('indicatorColor')) ?? Colors.blue,
          backgroundColor:
              payload.evalColor(props.get('bgColor')) ?? Colors.transparent,
          strokeWidth: props.getDouble('thickness') ?? 4.0,
        ),
      );
    } else {
      return CircularPercentIndicator(
        radius: (props.getDouble('size') ?? 50.0) / 2,
        lineWidth: props.getDouble('thickness') ?? 5.0,
        percent: progressValue != null ? progressValue / 100.0 : 0,
        animation: props.getBool('animation') ?? false,
        animateFromLastPercent:
            props.getBool('animateFromLastPercent') ?? false,
        backgroundColor:
            payload.evalColor(props.get('bgColor')) ?? Colors.transparent,
        progressColor:
            payload.evalColor(props.get('indicatorColor')) ?? Colors.blue,
        circularStrokeCap: CircularStrokeCap.round,
      );
    }
  }
}
