import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/progress_bar/linear/linear_progress_bar_props.dart';
import 'package:flutter/material.dart';

class DUILinearProgressBar extends StatefulWidget {
  final DUILinearProgressBarProps props;
  const DUILinearProgressBar(this.props, {super.key});

  @override
  State<DUILinearProgressBar> createState() => _DUILinearProgressBarState();
}

class _DUILinearProgressBarState extends State<DUILinearProgressBar> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(seconds: widget.props.animationDuration), // done
      curve: DUIDecoder.toCurve(widget.props.curve) ?? Curves.linear, // [TODO]
      tween: Tween<double>(
        begin: widget.props.animationBeginLength,
        end: widget.props.animationEndLength,
      ),
      builder: (context, value, _) {
        return SizedBox(
          width: widget.props.width,
          child: LinearProgressIndicator(
            color: widget.props.indicatorColor.let(toColor) ??
                Colors.blue, // [TODO]
            backgroundColor:
                widget.props.bgColor?.let(toColor) ?? Colors.transparent,
            minHeight: widget.props.thickness, // done
            borderRadius: BorderRadius.circular(
              widget.props.borderRadius ?? 0.0,
            ), // done
          ),
        );
      },
    );
  }
}
