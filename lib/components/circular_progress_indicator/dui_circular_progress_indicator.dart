import 'package:digia_ui/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/circular_progress_indicator/dui_circular_progress_indicator_props.dart';
import 'package:flutter/material.dart';

class DUICircularProgressIndicator extends StatelessWidget {
  final DUICircularProgressIndicatorProps props;
  const DUICircularProgressIndicator(this.props, {super.key});

  @override
  Widget build(BuildContext context) {
    // Non-Deterministic
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder<double>(
          duration: Duration(seconds: props.animationDuration), // done
          curve: DUIDecoder.toCurve(props.curves) ?? Curves.linear,
          tween: Tween<double>(
            begin: props.animationBeginLength,
            end: props.animationEndLength,
          ),
          builder: (context, value, _) {
            // ignore: prefer_const_constructors
            return CircularProgressIndicator(
              backgroundColor: props.bgColor?.let(toColor) ?? Colors.blue,
              color: props.indicatorColor?.let(toColor) ?? Colors.transparent,
              strokeWidth: props.strokeWidth,
              strokeAlign: props.strokeAlign,
              strokeCap: DUIDecoder.toStrokeCap(props.strokeCap),
            );
          },
        ),
      ),
    );
  }
}
