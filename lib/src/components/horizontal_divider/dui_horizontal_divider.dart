import 'package:flutter/material.dart';
import 'package:styled_divider/styled_divider.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../utils/decoder.dart';
import 'dui_horizontal_divider_props.dart';

class DUIHorizontalDivider extends StatelessWidget {
  final DUIHorizonatalDividerProps props;
  const DUIHorizontalDivider(this.props, {super.key});

  @override
  Widget build(BuildContext context) {
    return StyledDivider(
      lineStyle: toLineStyle(props.lineStyle) ?? DividerLineStyle.solid,
      height: props.height,
      thickness: props.thickness,
      indent: props.indent,
      endIndent: props.endIndent,
      color: props.color.let(toColor) ?? Colors.black,
    );
  }
}
