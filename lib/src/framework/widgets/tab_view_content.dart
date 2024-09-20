import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../core/extensions.dart';
import '../core/virtual_stateless_widget.dart';
import '../internal_widgets/internal_tab_controller.dart';
import '../render_payload.dart';

class VWTabViewContent extends VirtualStatelessWidget {
  VWTabViewContent({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    super.repeatData,
  });

  late InternalTabController _controller;

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();
    _controller = InternalTabControllerProvider.of(payload.buildContext);

    return TabBarView(
        controller: _controller,
        physics: props.getBool('isScrollable') ?? false
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        viewportFraction: props.getDouble('viewportFraction') ?? 1.0,
        children: List.generate(_controller.dynamicList!.length, (index) {
          return child!.toWidget(payload.copyWithChainedContext(
            _createExprContext(_controller.dynamicList![index], index),
          ));
        }));
  }

  ExprContext _createExprContext(Object? item, int index) {
    return ExprContext(variables: {'currentItem': item, 'index': index});
  }
}
