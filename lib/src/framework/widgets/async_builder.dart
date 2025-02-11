import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/async_builder/controller.dart';
import '../internal_widgets/async_builder/widget.dart';
import '../models/props.dart';
import '../models/types.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';
import '../utils/network_util.dart';
import '../utils/types.dart';

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

    final controller = payload.eval<AsyncController>(props.get('controller'))
      ?..setFutureCreator(
        () => _makeFuture(futureProps, payload),
      );

    return AsyncBuilder<Object?>(
        controller: controller,
        futureFactory: () => _makeFuture(futureProps, payload),
        builder: (innerCtx, snapshot) {
          final updatedPayload = payload.copyWithChainedContext(
              _createExprContext(
                  snapshot.data as Response<Object?>?, snapshot.error),
              buildContext: innerCtx);

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

            return errorWidget?.toWidget(updatedPayload) ??
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
          return successWidget.toWidget(updatedPayload);
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
      final apiDataSourceId = futureProps.getString('dataSource.ref');

      if (apiDataSourceId == null) {
        return Future.error('No API Selected');
      }

      final apiModel = payload.getApiModel(apiDataSourceId);

      if (apiModel == null) {
        return Future.error('No API Selected');
      }

      return executeApiAction(
        payload.scopeContext,
        apiModel,
        futureProps.getMap('dataSource.args')?.map((key, value) => MapEntry(
              key,
              ExprOr.fromJson<Object>(value),
            )),
        onSuccess: (response) async {
          final actionFlow = ActionFlow.fromJson(futureProps.get('onSuccess'));
          await payload.executeAction(
            actionFlow,
            scopeContext:
                DefaultScopeContext(variables: {'response': response}),
          );
        },
        onError: (response) async {
          final actionFlow = ActionFlow.fromJson(futureProps.get('onError'));
          await payload.executeAction(
            actionFlow,
            scopeContext:
                DefaultScopeContext(variables: {'response': response}),
          );
        },
      );

    case 'delay':
      return Future.delayed(
          Duration(milliseconds: futureProps.getInt('durationInMs') ?? 0));
  }
  return Future.error('No future type selected.');
}

JsonLike? _requestObjToMap(RequestOptions? requestOptions) {
  if (requestOptions == null) return null;

  return {
    'url': requestOptions.path,
    'method': requestOptions.method,
    'headers': requestOptions.headers,
    'data': requestOptions.data,
    'queryParameters': requestOptions.queryParameters,
  };
}
