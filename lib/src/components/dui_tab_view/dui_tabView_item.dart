import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../core/bracket_scope_provider.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import 'DUICustomTabController.dart';
import 'dui_tabview_item_props.dart';

class DUITabViewItem1 extends StatefulWidget {
  const DUITabViewItem1({
    required this.registry,
    required this.data,
    required this.duiTabView1Props,
    super.key,
  });

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

    final generateChildrenDynamically = _controller.dynamicList != null;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          child: TabBarView(
            controller: _controller,
            physics: widget.duiTabView1Props.isScrollable ?? false
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            viewportFraction: widget.duiTabView1Props.viewportFraction ?? 1.0,
            children: generateChildrenDynamically
                ? (widget.duiTabView1Props.allDynamic ?? true)
                    ? List.generate(_controller.dynamicList!.length, (index) {
                        final childToRepeat = children.first;
                        return BracketScope(
                          variables: [
                            ('index', index),
                            ('currentItem', _controller.dynamicList![index])
                          ],
                          builder: DUIJsonWidgetBuilder(
                            data: childToRepeat,
                            registry:
                                widget.registry ?? DUIWidgetRegistry.shared,
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
                            registry:
                                widget.registry ?? DUIWidgetRegistry.shared,
                          ),
                        );
                      })
                : children.map((e) {
                    return DUIJsonWidgetBuilder(
                      data: e,
                      registry: widget.registry ?? DUIWidgetRegistry.shared,
                    ).build(context);
                  }).toList(),
          ),
        );
      },
    );
    // return TabBarView(
    //   controller: _controller,
    //   physics: widget.duiTabView1Props.isScrollable ?? false
    //       ? const AlwaysScrollableScrollPhysics()
    //       : const NeverScrollableScrollPhysics(),
    //   viewportFraction: widget.duiTabView1Props.viewportFraction ?? 1.0,
    //   children: generateChildrenDynamically
    //       ? (widget.duiTabView1Props.allDynamic ?? true)
    //           ? List.generate(_controller.dynamicList!.length, (index) {
    //               final childToRepeat = children.first;
    //               return BracketScope(
    //                 variables: [
    //                   ('index', index),
    //                   ('currentItem', _controller.dynamicList![index])
    //                 ],
    //                 builder: DUIJsonWidgetBuilder(
    //                   data: childToRepeat,
    //                   registry: widget.registry ?? DUIWidgetRegistry.shared,
    //                 ),
    //               );
    //             })
    //           : List.generate(children.length, (index) {
    //               final childToRepeat = children[index];
    //               return BracketScope(
    //                 variables: [
    //                   ('index', index),
    //                   ('currentItem', _controller.dynamicList![index])
    //                 ],
    //                 builder: DUIJsonWidgetBuilder(
    //                   data: childToRepeat,
    //                   registry: widget.registry ?? DUIWidgetRegistry.shared,
    //                 ),
    //               );
    //             })
    //       : children.map((e) {
    //           return DUIJsonWidgetBuilder(
    //             data: e,
    //             registry: widget.registry ?? DUIWidgetRegistry.shared,
    //           ).build(context);
    //         }).toList(),
    // );
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
