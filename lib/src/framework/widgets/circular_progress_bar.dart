import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
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
    final bgColor = makeColor(payload.eval<String>(props['bgColor']));

    final indicatorColor =
        makeColor(payload.eval<String>(props['indicatorColor']));

    final strokeWidth = payload.eval<double>(props['strokeWidth']);

    final strokeAlign = payload.eval<double>(props['strokeAlign']);

    final progressValue = payload.eval<double>(props['progressValue']);

    final rotationInRadians =
        NumDecoder.toDouble(props['angle'])?.let((p0) => p0 / 180.0 * math.pi);

    return Transform.rotate(
      angle: rotationInRadians ?? 0.0,
      child: CircularProgressIndicator(
        value: progressValue == null ? null : progressValue / 100,
        backgroundColor: bgColor,
        color: indicatorColor,
        strokeWidth: strokeWidth ?? 4.0,
        strokeAlign: strokeAlign ?? CircularProgressIndicator.strokeAlignCenter,
        strokeCap: DUIDecoder.toStrokeCap(props['strokeCap']),
      ),
    );
  }
}
