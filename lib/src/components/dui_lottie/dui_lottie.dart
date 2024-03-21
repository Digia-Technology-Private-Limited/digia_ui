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
      alignment: getAlignment(widget.props.alignment ?? ''),
      height: widget.props.height,
      width: widget.props.width,
      animate: widget.props.animate ?? true,
      frameRate: FrameRate(widget.props.frameRate ?? 0.9),
      fit: DUIDecoder.toBoxFit(widget.props.fit ?? ''),
      reverse: widget.props.reverse,
      repeat: widget.props.repeat,
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

  AlignmentGeometry getAlignment(String fit) {
    switch (fit) {
      case 'center':
        return Alignment.center;
      case 'topLeft':
        return Alignment.topLeft;
      case 'topRight':
        return Alignment.topRight;
      case 'topCenter':
        return Alignment.topCenter;
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'centerRight':
        return Alignment.centerRight;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      case 'bottomRight':
        return Alignment.bottomRight;
      default:
        return Alignment.center;
    }
  }
}
