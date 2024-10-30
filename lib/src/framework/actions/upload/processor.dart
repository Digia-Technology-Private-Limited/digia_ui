import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../../../core/action/api_handler.dart';
import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../resource_provider.dart';
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
    super.logger,
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    UploadAction action,
    ScopeContext? scopeContext,
  ) async {
    final apiModel = ResourceProvider.maybeOf(context)?.apiModels[action.apiId];
    final progressStreamController = action.streamController
        ?.evaluate(scopeContext) as StreamController<Object?>?;
    final args = action.args?.map((k, v) => MapEntry(
          k,
          v?.evaluate(scopeContext),
        ));

    // final args = {'file': generateDummyFile(10)};
    if (apiModel == null) {
      return Future.error('No API Selected');
    }

    logger?.logAction(
      entitySlug: scopeContext!.name,
      actionType: action.actionType.value,
      actionData: {
        'apiId': action.apiId,
        'args': args,
      },
    );

    final result = ApiHandler.instance
        .execute(
            apiModel: apiModel,
            args: args,
            progressStreamController: progressStreamController)
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

// Uint8List generateDummyFile(int sizeInMB) {
//   int fileSize = sizeInMB * 1024 * 1024;
//   return Uint8List.fromList(List<int>.generate(fileSize, (i) => i % 256));
// }
