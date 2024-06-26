import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../action/action_handler.dart';
import '../action/action_prop.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';
import 'dui_icon_builder.dart';
import 'dui_text_builder.dart';

class DUIButtonBuilder extends DUIWidgetBuilder {
  DUIButtonBuilder({required super.data});

  static DUIButtonBuilder create(DUIWidgetJsonData data) {
    return DUIButtonBuilder(data: data);
  }

  factory DUIButtonBuilder.fromProps(Map<String, dynamic> props) {
    return DUIButtonBuilder(
      data: DUIWidgetJsonData(type: 'digia/button', props: props),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyleJson =
        data.props['defaultStyle'] as Map<String, dynamic>? ?? {};
    final disabledStyleJson =
        data.props['disabledStyle'] as Map<String, dynamic>? ?? {};

    ButtonStyle style = ButtonStyle(
        shape: MaterialStateProperty.all(toButtonShape(data.props['shape'])),
        padding: MaterialStateProperty.all(DUIDecoder.toEdgeInsets(
            defaultStyleJson['padding'],
            or: const EdgeInsets.symmetric(horizontal: 12, vertical: 4))),
        elevation: MaterialStateProperty.all(
            NumDecoder.toDouble(defaultStyleJson['elevation'])),
        shadowColor: MaterialStateProperty.all(defaultStyleJson['shadowColor']),
        alignment: DUIDecoder.toAlignment(defaultStyleJson['alignment']),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return ifNotNull(disabledStyleJson['backgroundColor'] as String?,
                (p0) => toColor(p0));
          }

          return ifNotNull(defaultStyleJson['backgroundColor'] as String?,
              (p0) => toColor(p0));
        }));

    final isDisabled = eval<bool>(data.props['isDisabled'], context: context) ??
        data.props['onClick'] == null;

    final disabledTextColor = disabledStyleJson['disabledTextColor'] as String?;
    final disabledIconColor = disabledStyleJson['disabledIconColor'] as String?;
    final content = _buildContent(context,
        overrideColor: isDisabled,
        disabledTextColor: disabledTextColor,
        disabledIconColor: disabledIconColor);

    return ElevatedButton(
        onPressed: isDisabled
            ? null
            : () {
                final onClick = ActionFlow.fromJson(data.props['onClick']);
                ActionHandler.instance
                    .execute(context: context, actionFlow: onClick);
              },
        style: style,
        child: content);
  }

  Map<String, dynamic> deepCopyMap(Map<String, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      if (value is Map) {
        newMap[key] = deepCopyMap(value as Map<String, dynamic>);
      } else {
        newMap[key] = value;
      }
    });
    return newMap;
  }

  Widget _buildContent(BuildContext context,
      {bool overrideColor = false,
      String? disabledTextColor,
      String? disabledIconColor}) {
    Widget text;
    Widget? leadingIcon;
    Widget? trailingIcon;

    final props = deepCopyMap(data.props);

    if (overrideColor) {
      props['text']?['textStyle']?['textColor'] = disabledTextColor;
    } else {
      props['text']?['textStyle']?['textColor'] =
          data.props['text']?['textStyle']?['textColor'];
    }

    final textBuilder =
        DUITextBuilder.fromProps(props: props['text'] as Map<String, dynamic>?);

    text = textBuilder.build(context);

    final leadingIconProps = props['leadingIcon'] as Map<String, dynamic>?;
    if (overrideColor) {
      leadingIconProps?['iconColor'] = disabledIconColor;
    } else {
      leadingIconProps?['iconColor'] =
          data.props.valueFor(keyPath: 'leadingIcon.iconColor');
    }

    leadingIcon =
        DUIIconBuilder.fromProps(props: leadingIconProps)?.build(context);

    final trailingIconProps = props['trailingIcon'] as Map<String, dynamic>?;
    if (overrideColor) {
      trailingIconProps?['iconColor'] = disabledIconColor;
    } else {
      trailingIconProps?['iconColor'] =
          data.props.valueFor(keyPath: 'trailingIcon.iconColor');
    }

    trailingIcon =
        DUIIconBuilder.fromProps(props: trailingIconProps)?.build(context);

    if (leadingIcon == null && trailingIcon == null) {
      return text;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) leadingIcon,
        Flexible(child: text),
        if (trailingIcon != null) trailingIcon,
      ],
    );
  }
}
