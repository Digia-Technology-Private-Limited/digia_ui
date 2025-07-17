import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/async_builder/controller.dart';
import '../internal_widgets/async_builder/widget.dart';
import '../models/types.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';
import '../utils/network_util.dart';
import '../utils/num_util.dart';
import '../utils/types.dart';
import '../widget_props/async_builder_props.dart';

enum FutureState {
  loading,
  completed,
  error;
}

enum FutureType {
  api,
  delay;
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
        final futureType = _getFutureType(props, payload);
        final updatedPayload = payload.copyWithChainedContext(
          _createExprContext(snapshot, futureType),
          buildContext: innerCtx,
        );
        return child?.toWidget(updatedPayload) ?? empty();
      },
    );
  }

  FutureType? _getFutureType(AsyncBuilderProps props, RenderPayload payload) {
    final futureProps = payload.evalExpr(props.future);
    final type = futureProps?['futureType'] as String?;

    switch (type) {
      case 'api':
        return FutureType.api;
      case 'delay':
        return FutureType.delay;
      default:
        return null;
    }
  }

  ScopeContext _createExprContext(
      AsyncSnapshot<Object?> snapshot, FutureType? futureType) {
    final String futureState = _getFutureState(snapshot);

    switch (futureType) {
      case FutureType.api:
        return _createApiExprContext(snapshot, futureState);
      case FutureType.delay:
        return _createDefaultExprContext(futureState);
      default:
        return _createDefaultExprContext(futureState);
    }
  }

  String _getFutureState(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      return FutureState.error.name;
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      return FutureState.loading.name;
    } else {
      return FutureState.completed.name;
    }
  }

  ScopeContext _createApiExprContext(
      AsyncSnapshot<Object?> snapshot, String futureState) {
    final response = snapshot.data as Response<Object?>?;

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

  ScopeContext _createDefaultExprContext(String futureState, {String? error}) {
    final respObj = {
      'futureState': futureState,
      if (error != null) 'error': error,
    };

    return DefaultScopeContext(
      variables: {
        ...respObj,
        ...?refName.maybe((it) => {it: respObj}),
      },
    );
  }

  Future<Object?> _makeFuture(
    AsyncBuilderProps props,
    RenderPayload payload,
  ) async {
    final futureProps = payload.evalExpr(props.future);
    if (futureProps == null) {
      return Future.error('Future props not provided');
    }

    final type = _getFutureType(props, payload);
    if (type == null) {
      return Future.error('Unknown Future Type');
    }

    switch (type) {
      case FutureType.api:
        return _makeApiFuture(futureProps, payload, props);
      case FutureType.delay:
        return _makeDelayFuture(futureProps);
    }
  }
}

Future<Object?> _makeApiFuture(
  JsonLike futureProps,
  RenderPayload payload,
  AsyncBuilderProps props,
) async {
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
        scopeContext: DefaultScopeContext(variables: {'response': response}),
      );
    },
    onError: (response) async {
      await payload.executeAction(
        props.onError,
        scopeContext: DefaultScopeContext(variables: {'response': response}),
      );
    },
  );
}

Future<Object?> _makeDelayFuture(JsonLike futureProps) async {
  final durationInMs = NumUtil.toInt(futureProps['durationInMs']) ?? 0;
  return Future.delayed(Duration(milliseconds: durationInMs));
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
