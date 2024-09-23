import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';

class VWCircularProgressBar extends VirtualLeafStatelessWidget {
  VWCircularProgressBar({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final bgColor = payload.evalColor(props.get('bgColor'));

    final indicatorColor = payload.evalColor(props.get('indicatorColor'));

    final strokeWidth = payload.eval<double>(props.get('strokeWidth'));

    final strokeAlign = payload.eval<double>(props.get('strokeAlign'));

    final progressValue = payload.eval<double>(props.get('progressValue'));

    final rotationInRadians =
        props.getDouble('angle').maybe((p0) => p0 / 180.0 * math.pi);

    return Transform.rotate(
      angle: rotationInRadians ?? 0.0,
      child: CircularProgressIndicator(
        value: progressValue == null ? null : progressValue / 100,
        backgroundColor: bgColor,
        color: indicatorColor,
        strokeWidth: strokeWidth ?? 4.0,
        strokeAlign: strokeAlign ?? CircularProgressIndicator.strokeAlignCenter,
        strokeCap: To.strokeCap(props.get('strokeCap')),
      ),
    );
  }
}
