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

    final wrapWithSliverToBoxAdapter = eval<bool>(
            data.containerProps['wrapWithSliverToBoxAdapter'],
            context: context) ??
        false;

    if (!isVisible) return const SizedBox.shrink();

    var current = build(context);
    if (data.containerProps.isEmpty) return current;

    if (wrapWithSliverToBoxAdapter) {
      return SliverToBoxAdapter(
        child: current,
      );
    }

    // Styling
    final styleClass = DUIStyleClass.fromJson(data.containerProps['style']);

    current = wrapInContainer(
        context: context, styleClass: styleClass, child: current);

    // Align
    current = DUIAlign(alignment: data.containerProps['align'], child: current);

    final onTapProp = ifNotNull(
        data.containerProps['onClick'] as Map<String, dynamic>?,
        (p0) => ActionFlow.fromJson(p0));

    current = DUIGestureDetector(
        context: context,
        actionFlow: onTapProp,
        child: current,
        borderRadius:
            DUIDecoder.toBorderRadius(styleClass?.border?.borderRadius));
    return current;
  }
}
