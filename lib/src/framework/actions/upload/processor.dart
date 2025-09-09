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
import '../action_descriptor.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class UploadProcessor extends ActionProcessor<UploadAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  }) executeActionFlow;

  UploadProcessor({
    required this.executeActionFlow,
  });

  @override
  Future<Object?>? execute(
      BuildContext context, UploadAction action, ScopeContext? scopeContext,
      {required String eventId, required String parentId}) async {
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

    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'apiModel': apiModel.toString(),
        'dataSource': action.dataSource?.toJson(),
        'hasProgressController': progressStreamController != null,
      },
    );

    executionContext?.notifyStart(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
    );

    // Listen to progress stream and emit progress events
    StreamSubscription<Object?>? progressSubscription;
    if (progressStreamController != null) {
      progressSubscription = progressStreamController.stream.listen(
        (progressData) {
          if (progressData is Map) {
            final progress = progressData['progress'] as double?;
            final count = progressData['count'] as int?;
            final total = progressData['total'] as int?;

            // Emit real-time upload progress with numeric percentage
            // Align with ApiHandler stream payload structure
            executionContext?.notifyProgress(
              eventId: eventId,
              parentId: parentId,
              descriptor: desc,
              details: {
                'count': count,
                'total': total,
                'progress': progress, // Numeric percentage from ApiHandler
                'percentage': progress, // Numeric percentage (primary field)
                'percentageString':
                    progress?.toStringAsFixed(1), // String format for display
              },
            );
          }
        },
        onError: (error) {
          // Emit progress: Upload stream error
          executionContext?.notifyProgress(
            eventId: eventId,
            parentId: parentId,
            descriptor: desc,
            details: {
              'error': error.toString(),
              'streamHealthy': false,
            },
          );
        },
      );
    }

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

      executionContext?.notifyComplete(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: null,
        stackTrace: null,
      );

      // Clean up progress subscription
      await progressSubscription?.cancel();

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
            ),
            parentId: parentId,
            eventId: eventId,
          );
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
            ),
            parentId: parentId,
            eventId: eventId,
          );
        }
      }
    }, onError: (error) async {
      executionContext?.notifyComplete(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: error,
        stackTrace: StackTrace.current,
      );

      // Clean up progress subscription
      await progressSubscription?.cancel();

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
          ),
          parentId: parentId,
          eventId: eventId,
        );
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
