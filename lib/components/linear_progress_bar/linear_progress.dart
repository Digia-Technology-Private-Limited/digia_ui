import 'package:digia_ui/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/linear_progress_bar/linear_progress_props.dart';
import 'package:flutter/material.dart';

class DUILinearProgress extends StatefulWidget {
  final DUILinearProgressProps props;
  const DUILinearProgress(this.props, {super.key});

  @override
  State<DUILinearProgress> createState() => _DUILinearProgressState();
}

class _DUILinearProgressState extends State<DUILinearProgress> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(seconds: widget.props.animationDuration), // done
      curve: DUIDecoder.toCurve(widget.props.curves) ?? Curves.linear, // [TODO]
      tween: Tween<double>(
        begin: widget.props.animationBeginLength,
        end: widget.props.animationEndLength,
      ),
      builder: (context, value, _) {
        return SizedBox(
          width: widget.props.width, // done
          child: LinearProgressIndicator(
            color: widget.props.indicatorColor?.let(toColor) ??
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
