import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
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
    final props = data.props;

    final value = eval<bool>(props['value'], context: context) ?? false;

    final size = NumDecoder.toDouble(props['size']) ?? 24;

    final activeColor = (props['activeColor'] as String?).letIfTrue(toColor);
    final inactiveColor =
        (props['inactiveColor'] as String?).letIfTrue(toColor);
    final BoxShape shape = switch (props.valueFor(keyPath: 'shape.value')) {
      'circle' => BoxShape.circle,
      _ => BoxShape.rectangle
    };
    final borderRadius = DUIDecoder.toBorderRadius(props['shape.borderRadius']);
    final activeBorderColor =
        (props['activeBorderColor'] as String?).letIfTrue(toColor);
    final inactiveBorderColor =
        (props['inactiveBorderColor'] as String?).letIfTrue(toColor);
    final borderWidth = NumDecoder.toDouble(props['borderWidth']);

    final activeIcon =
        DUIIconBuilder.fromProps(props: data.props['activeIcon']);
    final inactiveIcon = (data.props['inactiveIcon'] as Map<String, dynamic>?)
        .let((p0) => DUIIconBuilder.fromProps(props: p0));

    return Center(
      child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              color: value ? activeColor : inactiveColor,
              shape: shape,
              borderRadius: shape == BoxShape.circle ? null : borderRadius,
              border: Border.all(
                  width: borderWidth ?? 1.0,
                  style:
                      borderWidth == 0.0 ? BorderStyle.none : BorderStyle.solid,
                  color: (value ? activeBorderColor : inactiveBorderColor) ??
                      Colors.grey)),
          child:
              value ? activeIcon.build(context) : inactiveIcon?.build(context)),
    );
  }
}
