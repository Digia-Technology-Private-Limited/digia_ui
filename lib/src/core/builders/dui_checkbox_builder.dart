import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/util_functions.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';

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
    // Widget? activeIcon;
    // Widget? inactiveIcon;
    final props = data.props;

    final value = eval<bool>(props['initialValue'], context: context) ?? false;

    final activeColor = (props['activeColor'] as String?).let(toColor);
    final checkColor = (props['checkColor'] as String?).let(toColor);

    final size = NumDecoder.toDouble(props['size']) ?? 24;
    // final uncheckedColor = (props['uncheckedColor'] as String?).let(toColor);

    // final activeIconProps = data.props['activeIcon'] as Map<String, dynamic>?;

    // final inactiveIconProps =
    // data.props['inactiveIcon'] as Map<String, dynamic>?;

    // if (activeIconProps?['iconData'] != null) {
    //   activeIcon =
    //       DUIIconBuilder.fromProps(props: activeIconProps).build(context);
    // }
    // if (inactiveIconProps?['iconData'] != null) {
    //   inactiveIcon =
    //       DUIIconBuilder.fromProps(props: inactiveIconProps).build(context);
    // }

    return Transform.scale(
        scale: (size) / 24,
        child: Checkbox(
            shape: toButtonShape(data.props['shape']),
            checkColor: checkColor,
            activeColor: activeColor,
            splashRadius: 0,
            value: value,
            onChanged: (newValue) {}));

    // return Transform.scale(
    //   scale: (size ?? 24) / 24,
    //   child: GFCheckbox(
    //     type: props['shape'] == 'circle'
    //         ? GFCheckboxType.circle
    //         : GFCheckboxType.square,
    //     activeBgColor: activeBgColor,
    //     activeIcon: activeIcon ??
    //         const Icon(
    //           Icons.check,
    //           size: 16,
    //         ),
    //     inactiveBgColor: inactiveBgColor,
    //     inactiveIcon: inactiveIcon,
    //     size: size ?? 24,
    //     onChanged: (val) {
    //       value = eval<bool>(val, context: context) ?? false;
    //     },
    //     value: value,
    //   ),
    // );
  }
}
