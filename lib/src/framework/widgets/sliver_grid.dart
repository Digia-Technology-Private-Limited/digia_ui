import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../base/virtual_sliver.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';

class VWSliverGrid extends VirtualSliver<Props> {
  VWSliverGrid({
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
    if (child == null || !shouldRepeatChild) return empty();

    final items = payload.eval<List<Object>>(props.get('dataSource')) ?? [];

    final childToRepeat = child!;
    return SliverAlignedGrid.count(
      crossAxisCount: props.getInt('crossAxisCount') ?? 2,
      crossAxisSpacing: props.getDouble('crossAxisSpacing') ?? 0.0,
      mainAxisSpacing: props.getDouble('mainAxisSpacing') ?? 0.0,
      itemCount: items.length,
      itemBuilder: (innerCtx, index) =>
          childToRepeat.toWidget(payload.copyWithChainedContext(
        _createExprContext(items[index], index),
        buildContext: innerCtx,
      )),
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    final sliverGridObj = {
      'currentItem': item,
      'index': index,
    };

    return DefaultScopeContext(variables: {
      ...sliverGridObj,
      ...?refName.maybe((it) => {it: sliverGridObj}),
    });
  }
}
