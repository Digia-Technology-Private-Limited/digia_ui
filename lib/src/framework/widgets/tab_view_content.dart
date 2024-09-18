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
    if (children == null || children!.isEmpty) return empty();
    _controller = InternalTabControllerProvider.of(payload.buildContext);

    final generateChildrenDynamically = _controller.dynamicList != null;

    return TabBarView(
      controller: _controller,
      physics: props.getBool('isScrollable') ?? false
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      viewportFraction: props.getDouble('viewportFraction') ?? 1.0,
      children: generateChildrenDynamically
          ? List.generate(_controller.dynamicList!.length, (index) {
              final childToRepeat = children!.first;
              return childToRepeat.toWidget(payload.copyWithChainedContext(
                _createExprContext(_controller.dynamicList![index], index),
              ));
            })
          : children?.toWidgetArray(payload) ?? [],
    );
  }

  ExprContext _createExprContext(Object? item, int index) {
    return ExprContext(variables: {
      'currentItem': item,
      'index': index
      // TODO: Add class instance using refName
    });
  }
}
