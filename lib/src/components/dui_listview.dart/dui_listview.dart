import 'dart:async';

import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../core/builders/common.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import '../../core/evaluator.dart';
import '../../core/indexed_item_provider.dart';
import '../../core/page/props/dui_widget_json_data.dart';
import '../dui_base_stateful_widget.dart';

class DuiListview extends BaseStatefulWidget {
  final DUIWidgetJsonData data;
  final DUIWidgetRegistry? registry;

  const DuiListview({
    super.key,
    required super.varName,
    required this.data,
    this.registry,
  });

  @override
  DuiListviewState createState() => DuiListviewState();
}

class DuiListviewState extends DUIWidgetState<DuiListview> {
  late ValueNotifier<dynamic> _streamValueNotifier;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController(
      keepScrollOffset: true,
    );
    _scrollController.addListener(() {
      _streamValueNotifier.value = _scrollController.offset;
    });

    _streamValueNotifier = ValueNotifier<dynamic>(0);
  }

  Stream<dynamic> getListStream(dynamic offSet) {
    return Stream.value(offSet);
  }

  @override
  void dispose() {
    _streamValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.registry == null) {
      return fallbackWidget();
    }
    final children = widget.data.children['children']!;

    List items =
        createDataItemsForDynamicChildren(data: widget.data, context: context);
    final generateChildrenDynamically =
        widget.data.dataRef.isNotEmpty && widget.data.dataRef['kind'] != null;

    final initialScrollPosition = eval<String>(
        widget.data.props['initialScrollPosition'],
        context: context);
    final bool isReverse =
        eval<bool>(widget.data.props['reverse'], context: context) ?? false;

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
        scrollDirection: DUIDecoder.toAxis(widget.data.props['scrollDirection'],
            defaultValue: Axis.vertical),
        physics: DUIDecoder.toScrollPhysics(widget.data.props['allowScroll']),
        shrinkWrap: NumDecoder.toBoolOrDefault(widget.data.props['shrinkWrap'],
            defaultValue: false),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final childToRepeat = children.first;
          return IndexedItemWidgetBuilder(
              index: index,
              currentItem: items[index],
              builder: DUIJsonWidgetBuilder(
                  data: childToRepeat, registry: widget.registry!));
        },
      );
    } else {
      return ListView.builder(
        reverse: isReverse,
        controller: _scrollController,
        scrollDirection: DUIDecoder.toAxis(widget.data.props['scrollDirection'],
            defaultValue: Axis.vertical),
        physics: DUIDecoder.toScrollPhysics(widget.data.props['allowScroll']),
        shrinkWrap: NumDecoder.toBoolOrDefault(widget.data.props['shrinkWrap'],
            defaultValue: false),
        itemCount: children.length,
        itemBuilder: (context, index) {
          return DUIJsonWidgetBuilder(
                  data: children[index], registry: widget.registry!)
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

  Widget fallbackWidget() {
    return const Text('Registry not found for listview');
  }

  @override
  Map<String, Function> getVariables() {
    return {
      'scrollNotifier': () => _streamValueNotifier,
    };
  }
}
