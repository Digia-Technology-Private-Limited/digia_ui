import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';

class VWCircularProgressBar extends VirtualLeafStatelessWidget {
  VWCircularProgressBar({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final bgColor = makeColor(payload.eval<String>(props.get('bgColor')));

    final indicatorColor =
        makeColor(payload.eval<String>(props.get('indicatorColor')));

    final strokeWidth = payload.eval<double>(props.get('strokeWidth'));

    final strokeAlign = payload.eval<double>(props.get('strokeAlign'));

    final progressValue = payload.eval<double>(props.get('progressValue'));

    final rotationInRadians =
        props.getDouble('angle')?.let((p0) => p0 / 180.0 * math.pi);

    return Transform.rotate(
      angle: rotationInRadians ?? 0.0,
      child: CircularProgressIndicator(
        value: progressValue == null ? null : progressValue / 100,
        backgroundColor: bgColor,
        color: indicatorColor,
        strokeWidth: strokeWidth ?? 4.0,
        strokeAlign: strokeAlign ?? CircularProgressIndicator.strokeAlignCenter,
        strokeCap: DUIDecoder.toStrokeCap(props.get('strokeCap')),
      ),
    );
  }
}
