import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../core/bracket_scope_provider.dart';
import '../../core/builders/common.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import 'DUICustomTabController.dart';
import 'dui_tabview_item_props.dart';

class DUITabViewItem1 extends StatefulWidget {
  const DUITabViewItem1({
    required this.registry,
    required this.data,
    required this.duiTabView1Props,
    Key? key,
  }) : super(key: key);

  final DUIWidgetRegistry? registry;
  final DUIWidgetJsonData data;
  final DUITabViewItem1Props duiTabView1Props;

  @override
  State<DUITabViewItem1> createState() => _DUITabViewItem1State();
}

class _DUITabViewItem1State extends State<DUITabViewItem1> {
  late Duicustomtabcontroller _controller;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller = DuicustomTabControllerProvider.of(context);
    final children = widget.data.children['children'] ?? [];

    if (children.isEmpty) return _emptyChildWidget();

    List items =
        createDataItemsForDynamicChildren(data: widget.data, context: context);
    final generateChildrenDynamically =
        widget.data.dataRef.isNotEmpty && widget.data.dataRef['kind'] != null;

    return TabBarView(
      controller: _controller,
      physics: widget.duiTabView1Props.isScrollable ?? false
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      children: generateChildrenDynamically
          ? List.generate(items.length, (index) {
              final childToRepeat = children.first;
              return BracketScope(
                variables: [('index', index), ('currentItem', items[index])],
                builder: DUIJsonWidgetBuilder(
                  data: childToRepeat,
                  registry: widget.registry ?? DUIWidgetRegistry.shared,
                ),
              );
            })
          : children.map((e) {
              return DUIJsonWidgetBuilder(
                data: e,
                registry: widget.registry ?? DUIWidgetRegistry.shared,
              ).build(context);
            }).toList(),
    );
  }

  Widget _emptyControllerWidget() {
    return const Center(
      child: Text(
        'No Controller Found on Heirarchy',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _emptyChildWidget() {
    return const Center(
      child: Text(
        'Children field is Empty!',
        textAlign: TextAlign.center,
      ),
    );
  }
}
