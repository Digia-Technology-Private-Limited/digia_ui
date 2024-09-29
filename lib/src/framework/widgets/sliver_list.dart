import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWSliverList extends VirtualStatelessWidget<Props> {
  VWSliverList(
      {required super.props,
      required super.commonProps,
      required super.parent,
      required super.refName,
      required super.childGroups,
      required super.repeatData});

  bool get shouldRepeatChild => repeatData != null;

  @override
  Widget render(RenderPayload payload) {
    if (shouldRepeatChild) {
      if (children?.isEmpty ?? true) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }
      final items = payload.evalRepeatData(repeatData!);
      return SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final childToRepeat = children?.first;
          return childToRepeat?.toWidget(
            payload.copyWithChainedContext(
              _createExprContext(items[index], index),
            ),
          );
        },
      );
    } else {
      return SliverList.builder(
        itemCount: children?.length,
        itemBuilder: (context, index) {
          return children?[index].toWidget(
            payload.copyWithChainedContext(
              _createExprContext(children?[index], index),
            ),
          );
        },
      );
    }
  }

  ScopeContext _createExprContext(Object? item, int index) {
    return DefaultScopeContext(variables: {
      'currentItem': item,
      'index': index
      // TODO: Add class instance using refName
    });
  }
}
