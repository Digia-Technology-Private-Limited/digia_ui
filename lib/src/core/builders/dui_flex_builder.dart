import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/Utils/extensions.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:flutter/material.dart';

import '../../components/dui_widget_creator_fn.dart';

class DUIFlexBuilder extends DUIWidgetBuilder {
  Axis direction;

  DUIFlexBuilder(
      {required super.data, super.registry, required this.direction});

  static DUIFlexBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry, required Axis direction}) {
    return DUIFlexBuilder(data: data, registry: registry, direction: direction);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }

    final widget = Flex(
      mainAxisSize: MainAxisSize.min,
      direction: direction,
      mainAxisAlignment: DUIDecoder.toMainAxisAlginmentOrDefault(
          data.props['mainAxisAlignment'],
          defaultValue: MainAxisAlignment.start),
      crossAxisAlignment: DUIDecoder.toCrossAxisAlignmentOrDefault(
          data.props['crossAxisAlignment'],
          defaultValue: CrossAxisAlignment.center),
      children: !(data.children['children'].isNullOrEmpty)
          ? data.children['children']!.map((e) {
              return DUIFlexFit(
                  flex:
            e.containerProps.valueFor(keyPath: 'expansion.flexValue'),
            expansionType:
            e.containerProps.valueFor(keyPath: 'expansion.type'),
            child: DUIWidget(data: e));
      }).toList()
          : [
        const Text(
          'Children field is Empty!',
          textAlign: TextAlign.center,
        ),
      ],
    );

    if (data.props['isScrollable'] == true) {
      return SingleChildScrollView(
        scrollDirection: direction,
        child: widget,
      );
    }

    return widget;
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for FlexBuilder');
  }
}
