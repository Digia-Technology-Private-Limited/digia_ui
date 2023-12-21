import 'package:digia_ui/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/progress_bar/circular/circular_progress_bar_props.dart';
import 'package:flutter/material.dart';

class DUICircularProgressBar extends StatelessWidget {
  final DUICircularProgressBarProps props;
  const DUICircularProgressBar(this.props, {super.key});

  @override
  Widget build(BuildContext context) {
    // Non-Deterministic
    return TweenAnimationBuilder<double>(
      duration: Duration(seconds: props.animationDuration), // done
      curve: DUIDecoder.toCurve(props.curve) ?? Curves.linear,
      tween: Tween<double>(
        begin: props.animationBeginLength,
        end: props.animationEndLength,
      ),
      builder: (context, value, _) {
        // ignore: prefer_const_constructors
        return CircularProgressIndicator(
          backgroundColor: props.bgColor.let(toColor) ?? Colors.blue,
          color: props.indicatorColor.let(toColor) ?? Colors.transparent,
          strokeWidth: props.strokeWidth,
          strokeAlign: props.strokeAlign,
          strokeCap: DUIDecoder.toStrokeCap(props.strokeCap),
        );
      },
    );
  }
}
