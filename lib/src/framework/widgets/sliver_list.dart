import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../core/extensions.dart';
import '../core/virtual_stateless_widget.dart';
import '../render_payload.dart';

class VWSliverList extends VirtualStatelessWidget {
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
      return SliverList.builder(
        itemCount: children?.length ?? 0,
        itemBuilder: (context, index) {
          final childToRepeat = children?.first;
          return childToRepeat?.toWidget(
            payload.copyWithChainedContext(
              _createExprContext(children?[index], index),
            ),
          );
        },
      );
    } else {
      return SliverList.builder(
        itemCount: children?.length,
        itemBuilder: (context, index) {
          return child?.toWidget(
            payload.copyWithChainedContext(
              _createExprContext(children?[index], index),
            ),
          );
        },
      );
    }
  }

  ExprContext _createExprContext(Object? item, int index) {
    return ExprContext(variables: {
      'currentItem': item,
      'index': index
      // TODO: Add class instance using refName
    });
  }
}
