import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../../../core/action/api_handler.dart';
import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../models/types.dart';
import '../../resource_provider.dart';
import '../../utils/functional_util.dart';
import '../../utils/types.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class UploadProcessor extends ActionProcessor<UploadAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext,
  ) executeActionFlow;

  UploadProcessor({
    required this.executeActionFlow,
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    UploadAction action,
    ScopeContext? scopeContext,
  ) async {
    final dataSource = action.dataSource?.evaluate(scopeContext);
    final apiModel = ResourceProvider.maybeOf(context)
        ?.apiModels[as$<JsonLike>(dataSource)?['id']];
    final progressStreamController = action.streamController
        ?.evaluate(scopeContext) as StreamController<Object?>?;
    final apiCancelToken = action.cancelToken?.evaluate(scopeContext);
    final args = as$<JsonLike>(as$<JsonLike>(dataSource)?['args'])
        ?.map((key, value) => MapEntry(
              key,
              ExprOr.fromJson<Object>(value)?.evaluate(scopeContext),
            ));

    if (apiModel == null) {
      return Future.error('No API Selected');
    }

    logAction(
      action.actionType.value,
      {
        'dataSource': action.dataSource?.toJson(),
      },
    );

    final result = ApiHandler.instance
        .execute(
      apiModel: apiModel,
      args: args,
      progressStreamController: progressStreamController,
      cancelToken: apiCancelToken,
    )
        .then((response) async {
      final respObj = {
        'body': response.data,
        'statusCode': response.statusCode,
        'headers': response.headers,
        'requestObj': _requestObjToMap(response.requestOptions),
        'error': null,
      };
      final isSuccess = action.successCondition?.evaluate(scopeContext) ?? true;
      if (isSuccess) {
        if (!context.mounted) {
          return null;
        }
        if (action.onSuccess != null) {
          await executeActionFlow(
              context,
              action.onSuccess!,
              DefaultScopeContext(
                variables: {'response': respObj},
                enclosing: scopeContext,
              ));
        }
      } else {
        if (!context.mounted) {
          return null;
        }
        if (action.onError != null) {
          await executeActionFlow(
              context,
              action.onError!,
              DefaultScopeContext(
                variables: {'response': respObj},
                enclosing: scopeContext,
              ));
        }
      }
    }, onError: (error) async {
      if (!context.mounted) {
        return null;
      }
      if (error is DioException && action.onError != null) {
        final response = {
          'body': error.response?.data,
          'statusCode': error.response?.statusCode,
          'headers': error.response?.headers,
          'requestObj': _requestObjToMap(error.requestOptions),
          'error': error.message,
        };
        await executeActionFlow(
            context,
            action.onError!,
            DefaultScopeContext(
              variables: {'response': response},
              enclosing: scopeContext,
            ));
      }
    });

    return result;
  }

  Map<String, dynamic> _requestObjToMap(RequestOptions request) {
    return {
      'url': request.path,
      'method': request.method,
      'headers': request.headers,
      'data': request.data,
      'queryParameters': request.queryParameters,
    };
  }
}
