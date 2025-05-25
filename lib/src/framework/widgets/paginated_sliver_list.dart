import 'package:flutter/material.dart';

import '../base/virtual_sliver.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_paginated_sliver_list.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';
import '../utils/network_util.dart';
import '../widget_props/paginated_sliver_list_props.dart';

class VWPaginatedSliverList extends VirtualSliver<PaginatedSliverListProps> {
  VWPaginatedSliverList({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  bool get shouldRepeatChild => props.dataSource != null;

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.eval<List<Object>>(
              props.dataSource?.evaluate(payload.scopeContext)) ??
          [];
      final firstPageKey = payload.evalExpr(props.firstPageKey);

      return InternalPaginatedSliverList(
        items: items,
        firstPageKey: firstPageKey!,
        firstPageLoadingBuilder: childOf('firstPageLoadingWidget').maybe((it) {
          return (innerCtx) {
            return it.toWidget(payload.copyWith(buildContext: innerCtx));
          };
        }),
        newPageLoadingBuilder: childOf('newPageLoadingWidget').maybe((it) {
          return (innerCtx) {
            return it.toWidget(payload.copyWith(buildContext: innerCtx));
          };
        }),
        pageErrorBuilder: childOf('pageErrorWidget').maybe((it) {
          return (innerCtx) {
            return it.toWidget(payload.copyWith(buildContext: innerCtx));
          };
        }),
        itemBuilder: (innerCtx, index, data) {
          return childToRepeat.toWidget(
            payload.copyWithChainedContext(
              _createExprContext(data?[index], index),
              buildContext: innerCtx,
            ),
          );
        },
        pageRequestListener: (pageKey, controller) async {
          final apiModel = props.apiId.maybe((it) => payload.getApiModel(it));

          if (apiModel == null) return;

          final scope = DefaultScopeContext(
            variables: {'pageKey': pageKey},
            enclosing: payload.scopeContext,
          );

          await executeApiAction(
            scope,
            apiModel,
            props.args,
            onSuccess: (response) async {
              final newItems = props.transformItems?.evaluate(
                    DefaultScopeContext(
                      variables: {'response': response},
                      enclosing: scope,
                    ),
                  ) ??
                  as$<List>(response['body']);

              final nextPageKey = props.nextPageKey?.evaluate(
                DefaultScopeContext(
                  variables: {'response': response},
                  enclosing: scope,
                ),
              );

              if ((newItems == null || newItems.isEmpty) ||
                  (nextPageKey == null || nextPageKey == '')) {
                controller.appendLastPage([]);
              } else {
                controller.appendPage(newItems.cast<Object>(), nextPageKey);
              }
            },
          );
        },
      );
    }

    return SliverList.builder(
      itemCount: children!.length,
      itemBuilder: (cntx, index) {
        return children![index].toWidget(payload);
      },
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
