import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import 'dui_icon_props.dart';
import 'icon_helpers/icon_data_serialization.dart';

class DUIIcon extends StatelessWidget {
  final DUIIconProps _props;
  const DUIIcon(this._props, {super.key});

  @override
  Widget build(BuildContext context) {
    if (_props.iconData == null) {
      return const Text('');
    }

    final scope = DUIWidgetScope.of(context);
    var iconData =
        ifNotNull(_props.iconData, (p0) => scope?.iconDataProvider?.call(p0));

    iconData ??= getIconData(icondataMap: _props.iconData!);

    return Icon(iconData,
        size: _props.iconSize, color: _props.iconColor.let(toColor));
  }
}
