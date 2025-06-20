import 'package:flutter/material.dart';

import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_list_view.dart';
import '../internal_widgets/paginated_list_view.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';
import '../utils/network_util.dart';
import '../widget_props/paginated_list_view_props.dart';

class VWPaginatedListView
    extends VirtualStatelessWidget<PaginatedListViewProps> {
  VWPaginatedListView({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  bool get shouldRepeatChild => props.dataSource != null;

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    final initialScrollPosition = payload.evalExpr(props.initialScrollPosition);
    final isReverse = payload.evalExpr(props.reverse) ?? false;
    final firstPageKey = payload.evalExpr(props.firstPageKey);

    if (shouldRepeatChild) {
      final items = payload.eval<List<Object>>(
              props.dataSource?.evaluate(payload.scopeContext)) ??
          [];

      return PaginatedListView(
        firstPageKey: firstPageKey!,
        initialScrollPosition: initialScrollPosition ?? 'start',
        isReverse: isReverse,
        items: items,
        itemBuilder: (innerCtx, index, data) {
          return child!.toWidget(
            payload.copyWithChainedContext(
              _createExprContext(data?[index], index),
              buildContext: innerCtx,
            ),
          );
        },
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

    return InternalListView(
      controller: ScrollController(),
      reverse: isReverse,
      initialScrollPosition: initialScrollPosition,
      children: [child?.toWidget(payload) ?? empty()],
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    return DefaultScopeContext(variables: {
      'currentItem': item,
      'index': index,
    });
  }
}
