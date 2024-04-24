import 'package:digia_ui/src/core/builders/dui_icon_builder.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../../components/dui_widget_scope.dart';
import '../action/action_handler.dart';
import '../action/action_prop.dart';

class DUIIconButtonBuilder extends DUIWidgetBuilder {
  DUIIconButtonBuilder({required super.data});

  static DUIIconButtonBuilder create(DUIWidgetJsonData data) {
    return DUIIconButtonBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final eval = DUIWidgetScope.of(context)!.eval;
    final icon = DUIIconBuilder.fromProps(props: data.props['icon']);

    final defaultStyleJson =
        data.props['defaultStyle'] as Map<String, dynamic>? ?? {};
    final disabledStyleJson =
        data.props['disabledStyle'] as Map<String, dynamic>? ?? {};

    ButtonStyle style = ButtonStyle(
      padding: MaterialStateProperty.all(DUIDecoder.toEdgeInsets(
          defaultStyleJson['padding'],
          or: const EdgeInsets.symmetric(horizontal: 12, vertical: 4))),
      alignment: DUIDecoder.toAlignment(defaultStyleJson['alignment']),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return ifNotNull(disabledStyleJson['backgroundColor'] as String?,
              (p0) => toColor(p0));
        }
        return ifNotNull(defaultStyleJson['backgroundColor'] as String?,
            (p0) => toColor(p0));
      }),
    );

    final isDisabled =
        eval<bool>(data.props['isDisabled'], ((p0) => p0 as bool?)) ??
            data.props['onClick'] == null;
    final height = DUIDecoder.getHeight(context, data.props['height']);
    final width = DUIDecoder.getWidth(context, data.props['width']);

    return SizedBox(
        height: height,
        width: width,
        child: IconButton(
          onPressed: isDisabled
              ? null
              : () {
                  final onClick = ActionFlow.fromJson(data.props['onClick']);
                  ActionHandler.instance
                      .execute(context: context, actionFlow: onClick);
                },
          icon: icon.buildWithContainerProps(context),
          style: style,
        ));
  }
}
