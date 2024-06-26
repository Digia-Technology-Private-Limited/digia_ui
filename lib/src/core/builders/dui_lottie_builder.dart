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
    final (repeat, reverse) = getAnimationType(data.props['animationType']);

    return LottieBuilder.network(
      eval<String>(data.props['lottiePath'], context: context) ?? '',
      alignment: DUIDecoder.toAlignment(data.props['alignment']),
      height: DUIDecoder.getHeight(context, data.props['height']),
      width: DUIDecoder.getWidth(context, data.props['width']),
      animate: eval<bool>(data.props['animate'], context: context) ?? true,
      frameRate: FrameRate(data.props['frameRate'] ?? 60),
      fit: DUIDecoder.toBoxFit(data.props['fit']),
      repeat: repeat,
      reverse: reverse,
      errorBuilder: (context, object, stackTrace) {
        return SizedBox(
            height: DUIDecoder.getHeight(context, data.props['height']),
            width: DUIDecoder.getWidth(context, data.props['width']),
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
