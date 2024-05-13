import 'package:flutter/material.dart';

import '../../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../../Utils/basic_shared_utils/lodash.dart';
import '../../../Utils/util_functions.dart';
import 'circular_progress_bar_props.dart';

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
