import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../components/dui_widget_creator_fn.dart';
import '../bracket_scope_provider.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
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

    List items = _createDataItems(data.dataRef, context);
    final generateChildrenDynamically =
        data.dataRef.isNotEmpty && data.dataRef['kind'] != null;

    Widget widget;
    if (generateChildrenDynamically) {
      widget = _buildFlex(() {
        List<Widget> flexChildren = [];

        for (var i = 0; i < items.length; i++) {
          for (var child in children) {
            final element = items[i];
            final flexValue =
                child.containerProps.valueFor(keyPath: 'expansion.flexValue');
            final expansionType =
                child.containerProps.valueFor(keyPath: 'expansion.type');

            flexChildren.add(DUIFlexFit(
                flex: flexValue,
                expansionType: expansionType,
                child: BracketScope(
                    variables: [('index', i), ('currentItem', element)],
                    builder: DUIJsonWidgetBuilder(
                        data: child, registry: registry!))));
          }
        }

        return flexChildren;
      });
    } else {
      widget = _buildFlex(() {
        return children.map((e) {
          final builder = DUIJsonWidgetBuilder(data: e, registry: registry!);
          return builder.build(context);
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

  List<Object> _createDataItems(
      Map<String, dynamic> dataRef, BuildContext context) {
    if (dataRef.isEmpty) return [];
    if (data.dataRef['kind'] == 'json') {
      return _toList(data.dataRef['datum'])?.cast<Object>() ?? [];
    } else {
      return eval<List>(
            data.dataRef['datum'],
            context: context,
            decoder: (p0) => p0 as List?,
          )?.cast<Object>() ??
          [];
    }
  }

  List? _toList(dynamic data) {
    if (data is String) {
      try {
        final list = jsonDecode(data);
        if (list is! List) return null;
        return list;
      } catch (e) {
        return null;
      }
    }

    return data as List?;
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
