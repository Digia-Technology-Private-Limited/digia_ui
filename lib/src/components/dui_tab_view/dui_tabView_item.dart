// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../core/bracket_scope_provider.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import 'dui_custom_tab_controller.dart';
import 'dui_tabview_item_props.dart';

class DUITabViewItem1 extends StatelessWidget {
  DUITabViewItem1({
    Key? key,
    required this.registry,
    required this.data,
    required this.duiTabView1Props,
  }) : super(key: key);

  final DUIWidgetRegistry? registry;
  final DUIWidgetJsonData data;
  final DUITabViewItem1Props duiTabView1Props;

  late DUICustomTabController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = DUITabControllerProvider.of(context);
    final children = data.children['children'] ?? [];

    if (children.isEmpty) return _emptyChildWidget();

    final generateChildrenDynamically = _controller.dynamicList != null;

    return TabBarView(
      controller: _controller,
      physics: duiTabView1Props.isScrollable ?? false
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      viewportFraction: duiTabView1Props.viewportFraction ?? 1.0,
      children: generateChildrenDynamically
          ? (duiTabView1Props.allDynamic ?? true)
              ? List.generate(_controller.dynamicList!.length, (index) {
                  final childToRepeat = children.first;
                  return BracketScope(
                    variables: [
                      ('index', index),
                      ('currentItem', _controller.dynamicList![index])
                    ],
                    builder: DUIJsonWidgetBuilder(
                      data: childToRepeat,
                      registry: registry ?? DUIWidgetRegistry.shared,
                    ),
                  );
                })
              : List.generate(children.length, (index) {
                  final childToRepeat = children[index];
                  return BracketScope(
                    variables: [
                      ('index', index),
                      ('currentItem', _controller.dynamicList![index])
                    ],
                    builder: DUIJsonWidgetBuilder(
                      data: childToRepeat,
                      registry: registry ?? DUIWidgetRegistry.shared,
                    ),
                  );
                })
          : children.map((e) {
              return DUIJsonWidgetBuilder(
                data: e,
                registry: registry ?? DUIWidgetRegistry.shared,
              ).build(context);
            }).toList(),
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
