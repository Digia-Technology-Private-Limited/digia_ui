import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_lottie.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/lottie_props.dart';

class VWLottie extends VirtualLeafStatelessWidget<LottieProps> {
  VWLottie({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final (repeat, reverse) = getAnimationType(props.animationType);
    final alignment = To.alignment(payload.evalExpr(props.alignment));
    final height = payload.evalExpr(props.height);
    final width = payload.evalExpr(props.width);
    final animate = payload.evalExpr(props.animate) ?? true;
    final frameRate = FrameRate(payload.evalExpr(props.frameRate) ?? 60);
    final fit = To.boxFit(payload.evalExpr(props.fit));
    final lottiePath = payload.evalExpr(props.lottiePath);

    if (lottiePath == null) {
      return const Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
    }

    return InternalLottie(
      lottiePath: lottiePath,
      alignment: alignment ?? Alignment.center,
      height: height,
      width: width,
      animate: animate,
      frameRate: frameRate,
      fit: fit,
      repeat: repeat,
      reverse: reverse,
      onComplete: !repeat && props.onComplete != null
          ? () async {
              await payload.executeAction(
                props.onComplete!,
                triggerType: 'onComplete',
              );
            }
          : null,
    );
  }

  (bool repeat, bool reverse) getAnimationType(String? animationType) {
    final value = animationType ?? 'loop';

    switch (value) {
      case 'boomerang':
        return (true, true);
      case 'once':
        return (false, false);
      case 'loop':
      default:
        return (true, false);
    }
  }
}
