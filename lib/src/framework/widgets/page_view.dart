import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_page_view.dart';
import '../models/props.dart';

class VWPageView extends VirtualStatelessWidget<Props> {
  VWPageView(
      {super.refName,
      required super.props,
      required super.commonProps,
      required super.parent,
      required super.repeatData,
      required super.childGroups});

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    final childToRepeat = children!.first;
    final items = payload.evalRepeatData(repeatData!);
    final isReversed = payload.eval<bool>(props.get('reverse'));
    final initialPage = payload.eval<int>(props.get('initialPage'));
    final viewportFraction =
        payload.eval<double>(props.get('viewportFraction'));
    final keepPage = payload.eval<bool>(props.get('keepPage'));
    final pageSnapping = payload.eval<bool>(props.get('pageSnapping'));
    final controller = payload.eval<PageController>(props.get('controller'));
    final scrollDirection = To.axis(props.get('scrollDirection'));
    final physics = To.scrollPhysics(props.get('allowScroll'));
    final onPageChanged = ActionFlow.fromJson(props.getMap('onPageChanged'));
    return InternalPageView(
      pageSnapping: pageSnapping,
      reverse: isReversed,
      controller: controller,
      initialPage: initialPage,
      keepPage: keepPage,
      viewportFraction: viewportFraction,
      scrollDirection: scrollDirection,
      physics: physics,
      itemCount: items.length,
      itemBuilder: (innerCtx, index) => childToRepeat.toWidget(
        payload.copyWithChainedContext(
          _createExprContext(items[index], index),
          buildContext: innerCtx,
        ),
      ),
      onChanged: (index) async {
        await payload.executeAction(
          onPageChanged,
          scopeContext: _createExprContext(null, index),
        );
      },
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    return DefaultScopeContext(
        variables: {'currentItem': item, 'index': index});
  }
}
