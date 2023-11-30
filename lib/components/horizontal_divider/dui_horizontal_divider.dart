import 'package:digia_ui/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/horizontal_divider/dui_horizontal_divider_props.dart';
import 'package:flutter/material.dart';
import 'package:styled_divider/styled_divider.dart';

class DUIHorizontalDivider extends StatelessWidget {
  final DUIHorizonatalDividerProps props;
  const DUIHorizontalDivider(this.props, {super.key});

  @override
  Widget build(BuildContext context) {
    return  StyledDivider(
        lineStyle: DUIDecoder.decodeDividerlineStyle(props.lineStyle) ?? DividerLineStyle.solid,
        height: props.height,
        thickness: props.thickness,
        indent: props.indent,
        endIndent: props.endIndent,
        color: props.color?.let(toColor) ?? Colors.blue,
      
    );
  }
}
