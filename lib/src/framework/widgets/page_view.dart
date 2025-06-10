import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../data_type/adapted_types/page_controller.dart';
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
  bool get shouldRepeatChild => repeatData != null;
  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    final isReversed = payload.eval<bool>(props.get('reverse'));
    final initialPage = payload.eval<int>(props.get('initialPage'));
    final viewportFraction =
        payload.eval<double>(props.get('viewportFraction'));
    final keepPage = payload.eval<bool>(props.get('keepPage'));
    final pageSnapping = payload.eval<bool>(props.get('pageSnapping'));
    final controller =
        payload.eval<AdaptedPageController>(props.get('controller'));
    final scrollDirection = To.axis(props.get('scrollDirection'));
    final physics = To.scrollPhysics(props.get('allowScroll'));
    final onPageChanged = ActionFlow.fromJson(props.getMap('onPageChanged'));
    final padEnds = payload.eval<bool>(props.get('padEnds'));

    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.evalRepeatData(repeatData!);

      final preloadPages =
          payload.eval<bool>(props.get('preloadPages')) ?? false;

      int? itemCount;
      Widget Function(BuildContext context, int index)? itemBuilder;
      List<Widget> childPages = [];

      if (preloadPages) {
        childPages = items.mapIndexed((index, e) {
          return childToRepeat.toWidget(
            payload.copyWithChainedContext(_createExprContext(e, index)),
          );
        }).toList();
      } else {
        itemCount = items.length;
        itemBuilder = (innerCtx, index) => childToRepeat.toWidget(
              payload.copyWithChainedContext(
                _createExprContext(items[index], index),
                buildContext: innerCtx,
              ),
            );
      }

      return InternalPageView(
        pageSnapping: pageSnapping,
        reverse: isReversed,
        controller: controller,
        initialPage: initialPage,
        keepPage: keepPage,
        viewportFraction: viewportFraction,
        scrollDirection: scrollDirection,
        physics: physics,
        padEnds: padEnds,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        children: childPages,
        onChanged: (index) async {
          await payload.executeAction(
            onPageChanged,
            scopeContext: _createExprContext(null, index),
          );
        },
      );
    }

    return InternalPageView(
      pageSnapping: pageSnapping,
      reverse: isReversed,
      controller: controller,
      initialPage: initialPage,
      keepPage: keepPage,
      viewportFraction: viewportFraction,
      scrollDirection: scrollDirection,
      physics: physics,
      children: children?.toWidgetArray(payload) ?? [],
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
