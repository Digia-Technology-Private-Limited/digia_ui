import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../evaluator.dart';
import '../indexed_item_provider.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';
import 'common.dart';
import 'dui_json_widget_builder.dart';

class DUIListViewBuilder extends DUIWidgetBuilder {
  DUIListViewBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUIListViewBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIListViewBuilder(data, registry);
  }

  final ScrollController _scrollController = ScrollController();

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

    final initialScrollPosition =
        eval<String>(data.props['initialScrollPosition'], context: context);
    final bool isReverse =
        eval<bool>(data.props['reverse'], context: context) ?? false;

    if (initialScrollPosition == 'end') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToEnd();
      });
    }

    if (generateChildrenDynamically) {
      if (children.isEmpty) return const SizedBox.shrink();

      return ListView.builder(
        reverse: isReverse,
        controller: _scrollController,
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
        },
      );
    } else {
      return ListView.builder(
        reverse: isReverse,
        controller: _scrollController,
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
        },
      );
    }
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for listview');
  }
}
