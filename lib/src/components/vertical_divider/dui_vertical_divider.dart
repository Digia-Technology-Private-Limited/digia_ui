import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/utils/decoder.dart';
import 'package:digia_ui/src/components/vertical_divider/dui_vertical_divider_props.dart';
import 'package:flutter/material.dart';
import 'package:styled_divider/styled_divider.dart';

class DUIVerticalDivider extends StatelessWidget {
  final DUIVerticalDividerProps props;
  const DUIVerticalDivider(this.props, {super.key});

  @override
  Widget build(BuildContext context) {
    return StyledVerticalDivider(
      lineStyle: toLineStyle(props.lineStyle) ?? DividerLineStyle.solid,
      width: props.width,
      thickness: props.thickness,
      indent: props.indent,
      endIndent: props.endIndent,
      color: props.color.let(toColor) ?? Colors.black,
    );
  }
}
