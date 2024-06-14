import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../evaluator.dart';
import '../indexed_item_provider.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';
import 'dui_json_widget_builder.dart';

class DUIListViewBuilder extends DUIWidgetBuilder {
  DUIListViewBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUIListViewBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIListViewBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }
    final children = data.children['children']!;

    List items = _createDataItems(data.dataRef, context);
    final generateChildrenDynamically =
        data.dataRef.isNotEmpty && data.dataRef['kind'] != null;

    if (generateChildrenDynamically) {
      if (children.isEmpty) return const SizedBox.shrink();

      return ListView.builder(
          scrollDirection: DUIDecoder.toAxis(data.props['scrollDirection'],
              defaultValue: Axis.vertical),
          physics: DUIDecoder.toScrollPhysics(data.props['allowScroll']),
          shrinkWrap: NumDecoder.toBoolOrDefault(data.props['shrinkWrap'],
              defaultValue: false),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final childToRepeat = children.first;
            return IndexedItemWidgetBuilder(
                index: index,
                currentItem: items[index],
                builder: DUIJsonWidgetBuilder(
                    data: childToRepeat, registry: registry!));
          });
    } else {
      return ListView.builder(
          scrollDirection: DUIDecoder.toAxis(data.props['scrollDirection'],
              defaultValue: Axis.vertical),
          physics: DUIDecoder.toScrollPhysics(data.props['allowScroll']),
          shrinkWrap: NumDecoder.toBoolOrDefault(data.props['shrinkWrap'],
              defaultValue: false),
          itemCount: children.length,
          itemBuilder: (context, index) {
            return DUIJsonWidgetBuilder(
                    data: children[index], registry: registry!)
                .build(context);
          });
    }
  }

  List<Object> _createDataItems(
      Map<String, dynamic> dataRef, BuildContext context) {
    if (dataRef.isEmpty) return [];
    if (data.dataRef['kind'] == 'json') {
      return (data.dataRef['datum'] as List<dynamic>?)?.cast<Object>() ?? [];
    } else {
      return eval<List>(
            data.dataRef['datum'],
            context: context,
            decoder: (p0) => p0 as List?,
          )?.cast<Object>() ??
          [];
    }
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for listview');
  }
}
