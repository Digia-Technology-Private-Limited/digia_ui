import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class NavigateBackProcessor extends ActionProcessor<NavigateBackAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    NavigateBackAction action,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final maybe = action.maybe?.evaluate(scopeContext) ?? false;
    final result = {
      'data': action.result?.deepEvaluate(scopeContext),
    };

    final actionDescriptor = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'maybe': maybe,
        'result': result,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: actionDescriptor,
      observabilityContext: observabilityContext,
    );

    executionContext?.notifyProgress(
      id: id,
      parentActionId: parentActionId,
      descriptor: actionDescriptor,
      details: {
        'maybe': maybe,
        'result': result,
        'canPop': Navigator.of(context).canPop(),
      },
      observabilityContext: observabilityContext,
    );

    Object? navigationResult;
    try {
      if (maybe) {
        final popped = await Navigator.of(context).maybePop(result);
        navigationResult = popped;
      } else {
        Navigator.of(context).pop(result);
        navigationResult = null;
      }
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: actionDescriptor,
        error: null,
        stackTrace: null,
        observabilityContext: observabilityContext,
      );
      return navigationResult;
    } catch (e, st) {
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: actionDescriptor,
        error: e,
        stackTrace: st,
        observabilityContext: observabilityContext,
      );
      rethrow;
    }
  }
}
