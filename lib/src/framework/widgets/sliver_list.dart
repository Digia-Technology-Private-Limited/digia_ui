import 'package:flutter/widgets.dart';

import '../base/extensions.dart';
import '../base/virtual_sliver.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWSliverList extends VirtualSliver<Props> {
  VWSliverList({
    required super.props,
    required super.commonProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
    required super.repeatData,
  });

  bool get shouldRepeatChild => repeatData != null;

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    if (shouldRepeatChild) {
      final items = payload.evalRepeatData(repeatData!);

      final childToRepeat = children!.first;
      return SliverList.builder(
        itemCount: items.length,
        itemBuilder: (innerCtx, index) =>
            childToRepeat.toWidget(payload.copyWithChainedContext(
          _createExprContext(items[index], index),
          buildContext: innerCtx,
        )),
      );
    }
    return SliverList(
      delegate: SliverChildListDelegate(
        children?.toWidgetArray(payload) ?? [],
      ),
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    return DefaultScopeContext(variables: {
      'currentItem': item,
      'index': index
      // TODO: Add class instance using refName
    });
  }
}
