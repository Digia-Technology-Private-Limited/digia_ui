import 'package:digia_ui/Utils/util_functions.dart';
import 'package:flutter/material.dart';

import 'dui_icon_props.dart';

class DUIIcon extends StatelessWidget {
  const DUIIcon({super.key, required this.props});
  final DUIIconProps props;
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.abc, size: props.size, color: toColor(props.color));
  }
}
