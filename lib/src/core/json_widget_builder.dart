import 'package:flutter/material.dart';

import '../Utils/basic_shared_utils/dui_decoder.dart';
import '../Utils/basic_shared_utils/lodash.dart';
import '../Utils/dui_widget_registry.dart';
import '../components/dui_widget_creator_fn.dart';
import '../components/utils/DUIStyleClass/dui_style_class.dart';
import 'action/action_prop.dart';
import 'evaluator.dart';
import 'page/props/dui_widget_json_data.dart';

abstract class DUIWidgetBuilder {
  DUIWidgetJsonData data;
  DUIWidgetRegistry? registry;

  DUIWidgetBuilder({required this.data, this.registry});

  Widget build(BuildContext context);

  Widget fallbackWidget() =>
      Text('A widget of type: ${data.type} is not found');

  Widget buildWithContainerProps(BuildContext context) {
    final isVisible =
        eval<bool>(data.containerProps['visibility'], context: context) ?? true;

    if (!isVisible) return const SizedBox.shrink();

    var output = build(context);
    if (data.containerProps.isEmpty) return output;

    // Styling
    final styleClass = DUIStyleClass.fromJson(data.containerProps['style']);

    final onTapProp = ifNotNull(
        data.containerProps['onClick'] as Map<String, dynamic>?,
        (p0) => ActionFlow.fromJson(p0));

    output = DUIGestureDetector(
        context: context,
        actionFlow: onTapProp,
        child: output,
        borderRadius:
            DUIDecoder.toBorderRadius(styleClass?.border?.borderRadius));

    output = wrapInContainer(
        context: context, styleClass: styleClass, child: output);

    // Align
    output = DUIAlign(alignment: data.containerProps['align'], child: output);

    return output;
  }
}
