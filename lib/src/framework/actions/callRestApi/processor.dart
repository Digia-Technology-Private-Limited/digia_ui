import 'package:flutter/widgets.dart';

import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../models/types.dart';
import '../../resource_provider.dart';
import '../../utils/functional_util.dart';
import '../../utils/network_util.dart';
import '../../utils/types.dart';
import '../action_descriptor.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class CallRestApiProcessor extends ActionProcessor<CallRestApiAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  }) executeActionFlow;

  CallRestApiProcessor({
    super.executionContext,
    required this.executeActionFlow,
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    CallRestApiAction action,
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  }) async {
    try {
      final dataSource = action.dataSource?.evaluate(scopeContext);
      final apiModel = ResourceProvider.maybeOf(context)
          ?.apiModels[as$<JsonLike>(dataSource)?['id']];

      final desc = ActionDescriptor(
        id: eventId,
        type: action.actionType,
        definition: action.toJson(),
        resolvedParameters: {
          'dataSource': dataSource,
        },
      );

      executionContext?.notifyStart(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
      );

      if (apiModel == null) {
        final err = Exception('No API Selected');
        executionContext?.notifyComplete(
          eventId: eventId,
          parentId: parentId,
          descriptor: desc,
          error: err,
          stackTrace: StackTrace.current,
        );
        return Future.error(err);
      }

      executionContext?.notifyProgress(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        details: {'stage': 'request_started'},
      );

      final result = await executeApiAction(
        scopeContext,
        apiModel,
        as$<JsonLike>(as$<JsonLike>(dataSource)?['args'])?.map(
          (k, v) => MapEntry(k, ExprOr.fromJson<Object>(v)),
        ),
        successCondition: action.successCondition,
        onSuccess: (response) async {
          executionContext?.notifyProgress(
            eventId: eventId,
            parentId: parentId,
            descriptor: desc,
            details: {'stage': 'onSuccess', 'preview': _smallify(response)},
          );

          if (action.onSuccess != null) {
            await executeActionFlow(
              context,
              action.onSuccess!,
              DefaultScopeContext(
                variables: {'response': response},
                enclosing: scopeContext,
              ),
              eventId: eventId,
              parentId: eventId,
            );
          }
        },
        onError: (response) async {
          executionContext?.notifyProgress(
            eventId: eventId,
            parentId: parentId,
            descriptor: desc,
            details: {'stage': 'onError', 'preview': _smallify(response)},
          );

          if (action.onError != null) {
            await executeActionFlow(
              context,
              action.onError!,
              DefaultScopeContext(
                variables: {'response': response},
                enclosing: scopeContext,
              ),
              eventId: eventId,
              parentId: eventId,
            );
          }
        },
      );

      executionContext?.notifyComplete(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: null,
        stackTrace: null,
      );
      return result;
    } catch (e, st) {
      final desc = ActionDescriptor(
        id: eventId,
        type: action.actionType,
        definition: action.toJson(),
        resolvedParameters: {},
      );
      executionContext?.notifyComplete(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Map<String, dynamic> _smallify(Object? r) =>
      {'preview': r?.toString().substring(0, 200) ?? ''};
}
