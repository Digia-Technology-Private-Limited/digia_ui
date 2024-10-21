import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUILottieBuilder extends DUIWidgetBuilder {
  DUILottieBuilder({required super.data});

  static DUILottieBuilder create(DUIWidgetJsonData data) {
    return DUILottieBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final (repeat, reverse) =
        getAnimationType(data.props['animationType'] as String?);
    final alignment = DUIDecoder.toAlignment(data.props['alignment']);
    final height = DUIDecoder.getHeight(context, data.props['height']);
    final width = DUIDecoder.getWidth(context, data.props['width']);
    final animate = eval<bool>(data.props['animate'], context: context) ?? true;
    final frameRate = FrameRate(data.props['frameRate'] as double? ?? 60);
    final fit = DUIDecoder.toBoxFit(data.props['fit']);

    final lottiePath = eval<String>(data.props['lottiePath'], context: context);

    if (lottiePath == null) {
      return const Center(
        child: Icon(
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
        errorBuilder: (context, object, stackTrace) {
          return SizedBox(
              height: height,
              width: width,
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
              ));
        },
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
      errorBuilder: (context, object, stackTrace) {
        return SizedBox(
            height: height,
            width: width,
            child: const Icon(
              Icons.error_outline,
              color: Colors.red,
            ));
      },
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
