import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../../core/action/action_handler.dart';
import '../../core/action/api_handler.dart';
import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../internal_widgets/internal_paginated_list_view.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWPaginatedListView extends VirtualStatelessWidget<Props> {
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

    final initialScrollPosition =
        payload.eval<String>(props.getString('initialScrollPosition'));
    final isReverse = payload.eval<bool>(props.getBool('reverse'));

    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.evalRepeatData(repeatData!);

      return InternalPaginatedListView(
        firstPageLoadingWidget:
            childOf('firstPageLoadingWidget')?.toWidget(payload),
        newpageLoadingWidget:
            childOf('newPageLoadingWidget')?.toWidget(payload),
        pageErrorWidget: childOf('pageErrorWidget')?.toWidget(payload),
        initialScrollPosition: initialScrollPosition ?? 'start',
        isReverse: isReverse,
        scrollDirection: To.axis(props.get('scrollDirection')) ?? Axis.vertical,
        physics: To.scrollPhysics(props.get('allowScroll')),
        shrinkWrap: props.getBool('shrinkWrap') ?? false,
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
                exprContext: ExprContext(variables: {'offset': pageKey}));
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
                    exprContext:
                        ExprContext(variables: {'response': response}));

            if (newItems == null || newItems is! List || newItems.isEmpty) {
              controller.appendLastPage([]);
            } else {
              controller.appendPage(newItems.cast<Object>(), pageKey + 1);
            }
          });
        },
      );
    }

    return InternalPaginatedListView(
      isReverse: isReverse,
      scrollDirection: To.axis(props.get('scrollDirection')) ?? Axis.vertical,
      physics: To.scrollPhysics(props.get('allowScroll')),
      shrinkWrap: props.getBool('shrinkWrap') ?? false,
      children: children?.toWidgetArray(payload) ?? [],
    );
  }

  ExprContext _createExprContext(Object? item, int index) {
    return ExprContext(variables: {
      'currentItem': item,
      'index': index
      // TODO: Add class instance using refName
    });
  }
}
