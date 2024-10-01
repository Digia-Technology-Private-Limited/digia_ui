import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../../../core/action/api_handler.dart';
import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../resource_provider.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class CallRestApiProcessor extends ActionProcessor<CallRestApiAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext,
  ) executeActionFlow;

  CallRestApiProcessor({
    required this.executeActionFlow,
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    CallRestApiAction action,
    ScopeContext? scopeContext,
  ) async {
    final apiModel = ResourceProvider.maybeOf(context)?.apiModels[action.apiId];

    final args = action.args?.map((k, v) => MapEntry(
          k,
          v?.evaluate(scopeContext),
        ));

    if (apiModel == null) {
      return Future.error('No API Selected');
    }

    final result = ApiHandler.instance
        .execute(apiModel: apiModel, args: args)
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

  _requestObjToMap(RequestOptions request) {
    return {
      'url': request.path,
      'method': request.method,
      'headers': request.headers,
      'data': request.data,
      'queryParameters': request.queryParameters,
    };
  }
}
