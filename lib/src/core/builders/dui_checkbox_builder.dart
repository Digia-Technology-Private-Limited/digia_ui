import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/color_decoder.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import 'dui_icon_builder.dart';

class DUICheckboxBuilder extends DUIWidgetBuilder {
  DUICheckboxBuilder({required super.data});

  static DUICheckboxBuilder? create(DUIWidgetJsonData data) {
    return DUICheckboxBuilder(data: data);
  }

  factory DUICheckboxBuilder.fromProps({required Map<String, dynamic>? props}) {
    return DUICheckboxBuilder(
        data: DUIWidgetJsonData(type: 'digia/checkbox', props: props));
  }

  @override
  Widget build(BuildContext context) {
    Widget? activeIcon;
    Widget? inactiveIcon;
    final props = data.props;

    var value = eval<bool>(props['value'], context: context) ?? false;
    final size = NumDecoder.toDouble(props['size']);
    final activeBgColor =
        ColorDecoder.fromHexString(props['activeBgColor'] ?? '#04A24C');
    final inactiveBgColor =
        ColorDecoder.fromHexString(props['inactiveBgColor'] ?? '#E0E0E0');
    final activeIconProps = data.props['activeIcon'] as Map<String, dynamic>?;

    final inactiveIconProps =
        data.props['inactiveIcon'] as Map<String, dynamic>?;

    if (activeIconProps?['iconData'] != null) {
      activeIcon =
          DUIIconBuilder.fromProps(props: activeIconProps).build(context);
    }
    if (inactiveIconProps?['iconData'] != null) {
      inactiveIcon =
          DUIIconBuilder.fromProps(props: inactiveIconProps).build(context);
    }

    return Transform.scale(
      scale: (size ?? 24) / 24,
      child: GFCheckbox(
        type: props['shape'] == 'circle'
            ? GFCheckboxType.circle
            : GFCheckboxType.square,
        activeBgColor: activeBgColor,
        activeIcon: activeIcon ??
            const Icon(
              Icons.check,
              size: 16,
            ),
        inactiveBgColor: inactiveBgColor,
        inactiveIcon: inactiveIcon,
        size: size ?? 24,
        onChanged: (val) {
          value = val;
        },
        value: value,
      ),
    );
  }
}
