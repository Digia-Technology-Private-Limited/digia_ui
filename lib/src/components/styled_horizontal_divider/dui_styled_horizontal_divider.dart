import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../border/divider_with_pattern/divider_with_pattern.dart';
import 'dui_styled_horizontal_divider_props.dart';

class DUIStyledHorizontalDivider extends StatelessWidget {
  final DUIStyledHorizonatalDividerProps props;
  const DUIStyledHorizontalDivider(this.props, {super.key});

  @override
  Widget build(BuildContext context) {
    return DividerWithPattern(
      axis: Axis.horizontal,
      size: props.height,
      thickness: props.thickness,
      indent: props.indent,
      endIndent: props.endIndent,
      borderPattern:
          DUIDecoder.toBorderPattern(props.borderPattern?['value']) ??
              BorderPattern.solid,
      strokeCap: DUIDecoder.toStrokeCap(props.borderPattern?['strokeCap']) ??
          StrokeCap.butt,
      dashPattern:
          DUIDecoder.toDashPattern(props.borderPattern?['dashPattern']) ??
              [3, 3],
      color: makeColor(props.colorType?['color']),
      gradient: toGradiant(props.colorType?['gradiant'], context),
    );
  }
}
