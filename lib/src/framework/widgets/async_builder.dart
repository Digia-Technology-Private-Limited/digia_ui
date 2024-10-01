import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/action/api_handler.dart';
import '../actions/base/action_flow.dart';
import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/async_builder/controller.dart';
import '../internal_widgets/async_builder/widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';

class VWAsyncBuilder extends VirtualStatelessWidget<Props> {
  VWAsyncBuilder({
    required super.props,
    required super.commonProps,
    required super.parent,
    required super.childGroups,
    super.refName,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    final successWidget = childOf('successWidget');
    if (successWidget == null) return empty();

    final loadingWidget = childOf('loadingWidget');
    final errorWidget = childOf('errorWidget');

    final futureProps = props.toProps('future');
    if (futureProps == null) return empty();

    return AsyncBuilder<Response<Object?>>(
        controller: AsyncController<Response<Object?>>(
          futureBuilder: () => _makeFuture(futureProps, payload),
        ),
        builder: (innerCtx, snapshot) {
          final updatedPayload = payload.copyWith(buildContext: innerCtx);

          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingWidget?.toWidget(updatedPayload) ??
                const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            Future.delayed(const Duration(seconds: 0), () async {
              final actionFlow =
                  ActionFlow.fromJson(props.get('postErrorAction'));
              await updatedPayload.executeAction(actionFlow);
            });

            return errorWidget?.toWidget(
                  updatedPayload.copyWithChainedContext(
                    _createExprContext(
                      snapshot.data,
                      snapshot.error,
                    ),
                  ),
                ) ??
                Text(
                  'Error: ${snapshot.error?.toString()}',
                  style: const TextStyle(color: Colors.red),
                );
          }

          Future.delayed(const Duration(seconds: 0), () async {
            final actionFlow =
                ActionFlow.fromJson(props.get('postSuccessAction'));
            await updatedPayload.executeAction(actionFlow);
          });
          return successWidget.toWidget(
            updatedPayload.copyWithChainedContext(
              _createExprContext(
                snapshot.data,
                snapshot.error,
              ),
            ),
          );
        });
  }

  ScopeContext _createExprContext(Response<Object?>? response, Object? error) {
    final respObj = {
      'response': {
        'body': response?.data,
        'statusCode': response?.statusCode,
        'headers': response?.headers,
        'requestObj': _requestObjToMap(response?.requestOptions),
        'error': error,
      }
    };

    return DefaultScopeContext(variables: {
      ...respObj,
      ...?refName.maybe((it) => {it: respObj}),
    });
  }
}

Future<Response<Object?>> _makeFuture(
  Props futureProps,
  RenderPayload payload,
) async {
  final type = futureProps.getString('futureType');
  if (type == null) return Future.error('Type not selected');

  switch (type) {
    case 'api':
      final apiDataSourceId = futureProps.getString('dataSource.id');

      if (apiDataSourceId == null) {
        return Future.error('No API Selected');
      }

      Map<String, Object?>? apiDataSourceArgs =
          futureProps.getMap('dataSource.args');

      final apiModel = payload.getApiModel(apiDataSourceId);

      if (apiModel == null) {
        return Future.error('No API Selected');
      }

      final args = apiDataSourceArgs?.map((key, value) {
        final evalue = payload.eval(value);
        final dvalue = apiModel.variables?[key]?.defaultValue;
        return MapEntry(key, evalue ?? dvalue);
      });

      return ApiHandler.instance.execute(apiModel: apiModel, args: args).then(
          (response) async {
        final successAction = ActionFlow.fromJson(futureProps.get('onSuccess'));
        await payload.executeAction(
          successAction,
          scopeContext:
              DefaultScopeContext(variables: {'response': response.data}),
        );
        return response;
      }, onError: (e) async {
        final errorAction = ActionFlow.fromJson(futureProps.get('onFailure'));
        await payload.executeAction(
          errorAction,
          scopeContext: DefaultScopeContext(variables: {'error': e}),
        );
        throw e;
      });

    case 'delay':
      return Future.delayed(
          Duration(milliseconds: futureProps.getInt('durationInMs') ?? 0));
  }
  return Future.error('No future type selected.');
}

_requestObjToMap(RequestOptions? requestOptions) {
  if (requestOptions == null) return null;

  return {
    'url': requestOptions.path,
    'method': requestOptions.method,
    'headers': requestOptions.headers,
    'data': requestOptions.data,
    'queryParameters': requestOptions.queryParameters,
  };
}
