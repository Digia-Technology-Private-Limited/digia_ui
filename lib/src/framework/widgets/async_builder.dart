import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/async_builder/controller.dart';
import '../internal_widgets/async_builder/widget.dart';
import '../models/types.dart';
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
    required super.parent,
    required super.childGroups,
    super.refName,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    final futureProps = payload.evalExpr(props.future);
    if (futureProps == null) return empty();

    final controller = payload.eval<AsyncController>(props.controller)
      ?..setFutureCreator(
        () => _makeFuture(futureProps, payload),
      );

    return AsyncBuilder<Object?>(
      initialData: payload.evalExpr(props.initialData),
      controller: controller,
      futureFactory: () => _makeFuture(futureProps, payload),
      builder: (innerCtx, snapshot) {
        final updatedPayload = payload.copyWithChainedContext(
            _createExprContext(snapshot),
            buildContext: innerCtx);
        return child?.toWidget(updatedPayload) ?? empty();
      },
    );
  }

  ScopeContext _createExprContext(AsyncSnapshot<Object?> snapshot) {
    final response = snapshot.data as Response<Object?>?;
    final String futureState;
    if (snapshot.hasError) {
      futureState = AsyncFutureState.error.value;
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      futureState = AsyncFutureState.loading.value;
    } else {
      futureState = AsyncFutureState.completed.value;
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

Future<Response<Object?>> _makeFuture(
  JsonLike futureProps,
  RenderPayload payload,
) async {
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
          final actionFlow = ActionFlow.fromJson(futureProps['onSuccess']);
          await payload.executeAction(
            actionFlow,
            scopeContext:
                DefaultScopeContext(variables: {'response': response}),
          );
        },
        onError: (response) async {
          final actionFlow = ActionFlow.fromJson(futureProps['onError']);
          await payload.executeAction(
            actionFlow,
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
