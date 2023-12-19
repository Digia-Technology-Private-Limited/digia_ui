import 'package:digia_ui/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/dui_icons/dui_icon_props.dart';
import 'package:digia_ui/components/dui_icons/icon_helpers/icon_data_serialization.dart';
import 'package:flutter/material.dart';

class DUIIcon extends StatelessWidget {
  final DUIIconProps _props;
  const DUIIcon(this._props, {super.key});

  @override
  Widget build(BuildContext context) {

    if (_props.iconData == null) {
      return const Text('');
    }
    final IconData? iconData = getIconData(icondataMap: _props.iconData!);

    return Icon(
      iconData,
      size: _props.iconSize,
      color: _props.iconColor?.let(toColor),
    );
  }
}
