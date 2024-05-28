import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import 'dui_lottie_props.dart';

class DUILottie extends StatefulWidget {
  final DUILottieProps props;

  const DUILottie({super.key, required this.props});

  @override
  State<DUILottie> createState() => _DUILottieState();
}

class _DUILottieState extends State<DUILottie> {
  @override
  Widget build(BuildContext context) {
    final (repeat, reverse) = getAnimationType(widget.props.animationType);

    return LottieBuilder.network(
      widget.props.lottiePath ?? '',
      alignment: DUIDecoder.toAlignment(widget.props.alignment),
      height: widget.props.height,
      width: widget.props.width,
      animate: widget.props.animate ?? true,
      frameRate: FrameRate(widget.props.frameRate ?? 60),
      fit: DUIDecoder.toBoxFit(widget.props.fit),
      repeat: repeat,
      reverse: reverse,
      errorBuilder: (context, object, stackTrace) {
        return SizedBox(
            height: widget.props.height,
            width: widget.props.width,
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
