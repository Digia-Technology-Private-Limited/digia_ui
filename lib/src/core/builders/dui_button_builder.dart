import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/core/action/action_prop.dart';
import 'package:digia_ui/src/core/builders/dui_icon_builder.dart';
import 'package:digia_ui/src/core/builders/dui_text_builder.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

import '../../components/dui_widget_scope.dart';
import '../action/action_handler.dart';

class DUIButtonBuilder extends DUIWidgetBuilder {
  DUIButtonBuilder({required super.data});

  static DUIButtonBuilder create(DUIWidgetJsonData data) {
    return DUIButtonBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final eval = DUIWidgetScope.of(context)!.eval;
    final content = _buildContent(context);

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
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return ifNotNull(disabledStyleJson['foregroundColor'] as String?,
                (p0) => toColor(p0));
          }

          return ifNotNull(defaultStyleJson['foregroundColor'] as String?,
              (p0) => toColor(p0));
        }));

    final isDisabled =
        eval<bool>(data.props['isDisabled'], ((p0) => p0 as bool?)) ??
            data.props['onClick'] == null;

    final height = DUIDecoder.getHeight(context, data.props['height']);
    final width = DUIDecoder.getWidth(context, data.props['width']);

    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          onPressed: isDisabled
              ? null
              : () {
                  final onClick = ActionFlow.fromJson(data.props['onClick']);
                  ActionHandler.instance
                      .execute(context: context, actionFlow: onClick);
                },
          style: style,
          child: content),
    );
  }

  Widget _buildContent(BuildContext context) {
    Widget text;
    Widget? leadingIcon;
    Widget? trailingIcon;

    final textBuilder = DUITextBuilder.fromProps(
        props: data.props['text'] as Map<String, dynamic>?);

    text = textBuilder.build(context);

    final leadingIconProps = data.props['leadingIcon'] as Map<String, dynamic>?;

    if (leadingIconProps?['iconData'] != null) {
      leadingIcon =
          DUIIconBuilder.fromProps(props: leadingIconProps).build(context);
    }

    final trailingIconProps =
        data.props['trailingIcon'] as Map<String, dynamic>?;
    if (trailingIconProps?['iconData'] != null) {
      trailingIcon =
          DUIIconBuilder.fromProps(props: trailingIconProps).build(context);
    }

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
