import 'package:digia_inspector_core/digia_inspector_core.dart';
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
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
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
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    try {
      final dataSource = action.dataSource?.evaluate(scopeContext);
      final apiModel = ResourceProvider.maybeOf(context)
          ?.apiModels[as$<JsonLike>(dataSource)?['id']];

      final desc = ActionDescriptor(
        id: id,
        type: action.actionType,
        definition: action.toJson(),
        resolvedParameters: {
          'dataSource': dataSource,
        },
      );

      executionContext?.notifyStart(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        observabilityContext: observabilityContext,
      );

      if (apiModel == null) {
        final err = Exception('No API Selected');
        executionContext?.notifyComplete(
          id: id,
          parentActionId: parentActionId,
          descriptor: desc,
          error: err,
          stackTrace: StackTrace.current,
          observabilityContext: observabilityContext,
        );
        return Future.error(err);
      }

      executionContext?.notifyProgress(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        details: {'stage': 'request_started'},
        observabilityContext: observabilityContext,
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
            id: id,
            parentActionId: parentActionId,
            descriptor: desc,
            details: {'stage': 'onSuccess', 'preview': _smallify(response)},
            observabilityContext: observabilityContext,
          );

          if (action.onSuccess != null) {
            final onSuccessContext =
                observabilityContext?.forTrigger(triggerType: 'onSuccess');

            await executeActionFlow(
              context,
              action.onSuccess!,
              DefaultScopeContext(
                variables: {'response': response},
                enclosing: scopeContext,
              ),
              id: id,
              parentActionId: id,
              observabilityContext: onSuccessContext,
            );
          }
        },
        onError: (response) async {
          executionContext?.notifyProgress(
            id: id,
            parentActionId: parentActionId,
            descriptor: desc,
            details: {'stage': 'onError', 'preview': _smallify(response)},
            observabilityContext: observabilityContext,
          );

          if (action.onError != null) {
            final onErrorContext =
                observabilityContext?.forTrigger(triggerType: 'onError');

            await executeActionFlow(
              context,
              action.onError!,
              DefaultScopeContext(
                variables: {'response': response},
                enclosing: scopeContext,
              ),
              id: id,
              parentActionId: id,
              observabilityContext: onErrorContext,
            );
          }
        },
      );

      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: null,
        stackTrace: null,
        observabilityContext: observabilityContext,
      );
      return result;
    } catch (e, st) {
      final desc = ActionDescriptor(
        id: id,
        type: action.actionType,
        definition: action.toJson(),
        resolvedParameters: {},
      );
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: e,
        stackTrace: st,
        observabilityContext: observabilityContext,
      );
      rethrow;
    }
  }

  Map<String, dynamic> _smallify(Object? r) =>
      {'preview': r?.toString().substring(0, 200) ?? ''};
}
