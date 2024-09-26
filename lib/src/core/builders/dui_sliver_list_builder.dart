import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../bracket_scope_provider.dart';
import '../indexed_item_provider.dart';
import '../json_widget_builder.dart';
import 'common.dart';
import 'dui_json_widget_builder.dart';

class DUISliverListBuilder extends DUIWidgetBuilder {
  DUISliverListBuilder({required super.data, super.registry});

  static DUISliverListBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUISliverListBuilder(data: data, registry: registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }
    final children = data.children['children']!;
    List items =
        createDataItemsForDynamicChildren(data: data, context: context);
    final generateChildrenDynamically =
        data.dataRef.isNotEmpty && data.dataRef['kind'] != null;
    if (generateChildrenDynamically) {
      if (children.isEmpty) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }
      return SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final childToRepeat = children.first;
          return BracketScope(
              variables: [
                      ('index', index),
                      ('currentItem', items[index])
                    ],
              builder: DUIJsonWidgetBuilder(
                  data: childToRepeat, registry: registry!));
        },
      );
    } else {
      return SliverList.builder(
        itemCount: children.length,
        itemBuilder: (context, index) {
          return DUIJsonWidgetBuilder(
                  data: children[index], registry: registry!)
              .build(context);
        },
      );
    }
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for sliver list');
  }
}
