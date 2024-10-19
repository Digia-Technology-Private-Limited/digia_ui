import 'package:flutter/material.dart';

import '../base/extensions.dart';
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
    required super.repeatData,
  });

  bool get shouldRepeatChild => repeatData != null;

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    final initialScrollPosition = payload.evalExpr(props.initialScrollPosition);
    final isReverse = payload.evalExpr(props.reverse) ?? false;

    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.evalRepeatData(repeatData!);

      return PaginatedListView(
        initialScrollPosition: initialScrollPosition ?? 'start',
        isReverse: isReverse,
        items: items,
        itemBuilder: (innerCtx, index, data) {
          return childToRepeat.toWidget(
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
            variables: {'offset': pageKey},
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

              if (newItems == null || newItems.isEmpty) {
                controller.appendLastPage([]);
              } else {
                controller.appendPage(newItems.cast<Object>(), pageKey + 1);
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
      itemCount: children?.length ?? 0,
      children: children?.toWidgetArray(payload) ?? [],
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    return DefaultScopeContext(variables: {
      'currentItem': item,
      'index': index,
    });
  }
}
