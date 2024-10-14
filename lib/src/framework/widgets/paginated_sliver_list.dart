import 'package:flutter/material.dart';

import '../../core/action/action_handler.dart';
import '../../core/action/api_handler.dart';
import '../base/virtual_sliver.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_paginated_sliver_list.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';
import '../widget_props/paginated_sliver_list_props.dart';

class VWPaginatedSliverList extends VirtualSliver<PaginatedSliverListProps> {
  VWPaginatedSliverList({
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

    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.evalRepeatData(repeatData!);

      return InternalPaginatedSliverList(
        items: items,
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
        pageRequestListener: (pageKey, controller) {
          final apiModel = props.apiId.maybe((it) => payload.getApiModel(it));

          if (apiModel == null) return;

          final args = apiModel.variables?.map((k, v) => MapEntry(
                k,
                props.args?[k]?.evaluate(
                        DefaultScopeContext(variables: {'offset': pageKey})) ??
                    v.defaultValue,
              ));

          ApiHandler.instance
              .execute(apiModel: apiModel, args: args)
              .then((resp) {
            final response = {
              'body': resp.data,
              'statusCode': resp.statusCode,
              'headers': resp.headers,
              'requestObj': requestObjToMap(resp.requestOptions),
              'error': null,
            };

            final newItems = props.transformItems?.evaluate(DefaultScopeContext(
                  variables: {'response': response},
                  enclosing: payload.scopeContext,
                )) ??
                as$<List>(response['body']);

            if (newItems == null || newItems.isEmpty) {
              controller.appendLastPage([]);
            } else {
              controller.appendPage(newItems.cast<Object>(), pageKey + 1);
            }
          });
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
