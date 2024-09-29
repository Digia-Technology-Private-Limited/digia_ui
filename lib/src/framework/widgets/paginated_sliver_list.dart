import 'package:flutter/material.dart';

import '../../core/action/action_handler.dart';
import '../../core/action/api_handler.dart';
import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_paginated_sliver_list.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWPaginatedSliverList extends VirtualStatelessWidget<Props> {
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
        firstPageLoadingWidget:
            childOf('firstPageLoadingWidget')?.toWidget(payload),
        newpageLoadingWidget:
            childOf('newPageLoadingWidget')?.toWidget(payload),
        pageErrorWidget: childOf('pageErrorWidget')?.toWidget(payload),
        itemBuilder: (buildContext, index) => childToRepeat.toWidget(
          payload.copyWithChainedContext(
            _createExprContext(items[index], index),
          ),
        ),
        apiRequestHandler: (pageKey, controller) {
          final apiDataSourceId = props.getString('dataSource.id');
          Map<String, Object?>? apiDataSourceArgs =
              props.getMap('dataSource.args');
          if (apiDataSourceId == null) {
            return;
          }
          final apiModel = payload.getApiModel(apiDataSourceId);
          if (apiModel == null) {
            return;
          }
          final args = apiDataSourceArgs?.map((key, value) {
            final evalue = payload.eval(value,
                scopeContext:
                    DefaultScopeContext(variables: {'offset': pageKey}));
            final dvalue = apiModel.variables?[key]?.defaultValue;
            return MapEntry(key, evalue ?? dvalue);
          });

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

            final newItems = props.get('newItemsTransformation') == null
                ? response['body']
                : payload.eval<List>(props.get('newItemsTransformation'),
                    scopeContext:
                        DefaultScopeContext(variables: {'response': response}));

            if (newItems == null || newItems is! List || newItems.isEmpty) {
              controller.appendLastPage([]);
            } else {
              controller.appendPage(newItems.cast<Object>(), pageKey + 1);
            }
          });
        },
      );
    }

    return InternalPaginatedSliverList(
      children: children?.toWidgetArray(payload) ?? [],
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
