import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';

class VWLottie extends VirtualLeafStatelessWidget {
  VWLottie({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final (repeat, reverse) =
        getAnimationType(props.getString('animationType'));
    final alignment = DUIDecoder.toAlignment(props.get('alignment'));
    final height =
        DUIDecoder.getHeight(payload.buildContext, props.get('height'));
    final width = DUIDecoder.getWidth(payload.buildContext, props.get('width'));
    final animate = payload.eval<bool>(props.get('animate')) ?? true;
    final frameRate = FrameRate(props.getDouble('frameRate') ?? 60);
    final fit = DUIDecoder.toBoxFit(props.get('fit'));

    final lottiePath = payload.eval<String>(props.get('lottiePath'));

    if (lottiePath == null) {
      return const Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
    }

    Widget errorBuilder(
        BuildContext context, dynamic object, StackTrace? stackTrace) {
      return SizedBox(
        height: height,
        width: width,
        child: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
    }

    if (lottiePath.startsWith('http')) {
      return LottieBuilder.network(
        lottiePath,
        alignment: alignment,
        height: height,
        width: width,
        animate: animate,
        frameRate: frameRate,
        fit: fit,
        repeat: repeat,
        reverse: reverse,
        errorBuilder: errorBuilder,
      );
    }

    return LottieBuilder.asset(
      lottiePath,
      alignment: alignment,
      height: height,
      width: width,
      animate: animate,
      frameRate: frameRate,
      fit: fit,
      repeat: repeat,
      reverse: reverse,
      errorBuilder: errorBuilder,
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
