import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/components/dui_lottie/dui_lottie_props.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DUILottie extends StatefulWidget {
  final DUILottieProps props;

  const DUILottie({super.key, required this.props});

  @override
  State<DUILottie> createState() => _DUILottieState();
}

class _DUILottieState extends State<DUILottie> {
  @override
  Widget build(BuildContext context) {
    return LottieBuilder.network(
      widget.props.lottiePath ?? '',
      alignment: DUIDecoder.toAlignment(widget.props.alignment),
      height: widget.props.height,
      width: widget.props.width,
      animate: widget.props.animate ?? true,
      frameRate: FrameRate(widget.props.frameRate ?? 60),
      fit: DUIDecoder.toBoxFit(widget.props.fit ?? ''),
      repeat: getAnimationType(widget.props.animationType ?? '').$1,
      reverse: getAnimationType(widget.props.animationType ?? '').$2,
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

  (bool repeat, bool reverse) getAnimationType(String animationType) {
    switch (animationType) {
      case 'loop':
        return (true, false);
      case 'boomerang':
        return (true, true);
      case 'once':
        return (false, false);
      default:
        return (true, false);
    }
  }
}
