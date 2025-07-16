import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/async_builder/controller.dart';
import '../internal_widgets/async_builder/widget.dart';
import '../models/types.dart';
import '../page_performance_monitor.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';
import '../utils/network_util.dart';
import '../utils/types.dart';
import '../widget_props/async_builder_props.dart';

enum AsyncFutureState {
  loading,
  completed,
  error;

  String get value => name;
}

class VWAsyncBuilder extends VirtualStatelessWidget<AsyncBuilderProps> {
  VWAsyncBuilder({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    required super.childGroups,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final controller = payload.evalExpr<AsyncController>(props.controller)
      ?..setFutureCreator(
        () => _makeFuture(props, payload),
      );

    return AsyncBuilder<Object?>(
      initialData: payload.evalExpr(props.initialData),
      controller: controller,
      futureFactory: () => _makeFuture(props, payload),
      builder: (innerCtx, snapshot) {
        final updatedPayload = payload.copyWithChainedContext(
            _createExprContext(snapshot),
            buildContext: innerCtx);
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            PagePerformanceMonitor().markTimeToInteractive('Future');
          });
        }
        return child?.toWidget(updatedPayload) ?? empty();
      },
    );
  }

  ScopeContext _createExprContext(AsyncSnapshot<Object?> snapshot) {
    final String futureState;
    final Response<Object?>? response;
    if (snapshot.hasError) {
      futureState = AsyncFutureState.error.value;
      response = null;
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      futureState = AsyncFutureState.loading.value;
      response = null;
    } else {
      futureState = AsyncFutureState.completed.value;
      response = snapshot.data as Response<Object?>?;
    }

    final respObj = {
      'futureState': futureState,
      'response': {
        'body': response?.data,
        'statusCode': response?.statusCode,
        'headers': response?.headers,
        'requestObj': _requestObjToMap(response?.requestOptions),
        'error': snapshot.error,
      }
    };

    return DefaultScopeContext(
      variables: {
        ...respObj,
        ...?refName.maybe((it) => {it: respObj}),
      },
    );
  }
}

Future<Object?> _makeFuture(
  AsyncBuilderProps props,
  RenderPayload payload,
) async {
  final futureProps = payload.evalExpr(props.future);
  if (futureProps == null) return Future.error('Future props not provided');

  final type = futureProps['futureType'];
  if (type == null) return Future.error('Type not selected');

  switch (type) {
    case 'api':
      final dataSource = futureProps['dataSource'] as JsonLike?;
      final apiDataSourceId = dataSource?['id'] as String?;

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
        as$<JsonLike>(dataSource?['args'])?.map((key, value) => MapEntry(
              key,
              ExprOr.fromJson<Object>(value),
            )),
        onSuccess: (response) async {
          await payload.executeAction(
            props.onSuccess,
            scopeContext:
                DefaultScopeContext(variables: {'response': response}),
          );
        },
        onError: (response) async {
          await payload.executeAction(
            props.onError,
            scopeContext:
                DefaultScopeContext(variables: {'response': response}),
          );
        },
      );

    case 'delay':
      return Future.delayed(
          Duration(milliseconds: futureProps['durationInMs'] as int? ?? 0));
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
