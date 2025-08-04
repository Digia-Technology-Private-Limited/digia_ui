import 'package:flutter/widgets.dart';

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
    if (children == null || children!.isEmpty) return empty();

    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: props.getInt('crossAxisCount') ?? 2,
    );

    if (shouldRepeatChild) {
      final items = payload.eval<List<Object>>(props.get('dataSource')) ?? [];

      final childToRepeat = children!.first;
      return SliverGrid.builder(
        itemCount: items.length,
        itemBuilder: (innerCtx, index) =>
            childToRepeat.toWidget(payload.copyWithChainedContext(
          _createExprContext(items[index], index),
          buildContext: innerCtx,
        )),
        gridDelegate: gridDelegate,
      );
    }
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => children![index].toWidget(
          payload.copyWithChainedContext(
            _createExprContext(children![index], index),
            buildContext: context,
          ),
        ),
        childCount: children?.length ?? 0,
      ),
      gridDelegate: gridDelegate,
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
