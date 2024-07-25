import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../components/dui_widget_creator_fn.dart';
import '../bracket_scope_provider.dart';
import '../json_widget_builder.dart';
import 'common.dart';
import 'dui_json_widget_builder.dart';

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

    final children = data.children['children'] ?? [];

    if (children.isEmpty) return _emptyChildWidget();

    List items =
        createDataItemsForDynamicChildren(data: data, context: context);
    final generateChildrenDynamically =
        data.dataRef.isNotEmpty && data.dataRef['kind'] != null;

    Widget widget;
    if (generateChildrenDynamically) {
      widget = _buildFlex(() {
        return items
            .mapIndexed((index, element) {
              return children.map((child) {
                final flexValue = child.containerProps
                    .valueFor(keyPath: 'expansion.flexValue');
                final expansionType =
                    child.containerProps.valueFor(keyPath: 'expansion.type');

                return DUIFlexFit(
                    flex: flexValue,
                    expansionType: expansionType,
                    child: BracketScope(
                        variables: [('index', index), ('currentItem', element)],
                        builder: DUIJsonWidgetBuilder(
                            data: child, registry: registry!)));
              });
            })
            .expand((e) => e)
            .toList();
      });
    } else {
      widget = _buildFlex(() {
        return children.map((child) {
          final flexValue =
              child.containerProps.valueFor(keyPath: 'expansion.flexValue');
          final expansionType =
              child.containerProps.valueFor(keyPath: 'expansion.type');
          final builder =
              DUIJsonWidgetBuilder(data: child, registry: registry!);
          return DUIFlexFit(
              flex: flexValue,
              expansionType: expansionType,
              child: builder.build(context));
        }).toList();
      });
    }

    if (data.props['isScrollable'] == true) {
      return SingleChildScrollView(
        scrollDirection: direction,
        child: widget,
      );
    }

    return widget;
  }

  Flex _buildFlex(List<Widget> Function() childrenBuilder) {
    return Flex(
        mainAxisSize: DUIDecoder.toMainAxisSizeOrDefault(
          data.props['mainAxisSize'],
          defaultValue: MainAxisSize.min,
        ),
        direction: direction,
        mainAxisAlignment: DUIDecoder.toMainAxisAlginmentOrDefault(
            data.props['mainAxisAlignment'],
            defaultValue: MainAxisAlignment.start),
        crossAxisAlignment: DUIDecoder.toCrossAxisAlignmentOrDefault(
            data.props['crossAxisAlignment'],
            defaultValue: CrossAxisAlignment.center),
        children: childrenBuilder());
  }

  Widget _emptyChildWidget() {
    return const Text(
      'Children field is Empty!',
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for FlexBuilder');
  }
}
