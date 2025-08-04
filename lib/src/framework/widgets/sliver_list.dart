import 'package:flutter/widgets.dart';

import '../base/virtual_sliver.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';

class VWSliverList extends VirtualSliver<Props> {
  VWSliverList({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
  });

  bool get shouldRepeatChild => props.get('dataSource') != null;

  @override
  Widget render(RenderPayload payload) {
    if (shouldRepeatChild) {
      final items = payload.eval<List<Object>>(props.get('dataSource')) ?? [];

      return SliverList.builder(
        itemCount: items.length,
        itemBuilder: (innerCtx, index) =>
            child?.toWidget(payload.copyWithChainedContext(
          _createExprContext(items[index], index),
          buildContext: innerCtx,
        )),
      );
    }
    return SliverList(
      delegate: SliverChildListDelegate(
        [child?.toWidget(payload) ?? empty()],
      ),
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    final sliverListObj = {
      'currentItem': item,
      'index': index,
    };

    return DefaultScopeContext(variables: {
      ...sliverListObj,
      ...?refName.maybe((it) => {it: sliverListObj}),
    });
  }
}
