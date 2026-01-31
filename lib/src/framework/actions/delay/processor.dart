import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class DelayProcessor extends ActionProcessor<DelayAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    DelayAction action,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final durationInMs = action.durationInMs?.evaluate(scopeContext);

    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'durationInMs': durationInMs,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      observabilityContext: observabilityContext,
    );

    executionContext?.notifyProgress(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      details: {
        'durationInMs': durationInMs,
        'durationIsNull': durationInMs == null,
      },
      observabilityContext: observabilityContext,
    );

    if (durationInMs != null) {
      await Future<void>.delayed(Duration(milliseconds: durationInMs));
    }

    executionContext?.notifyComplete(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      error: null,
      stackTrace: null,
      observabilityContext: observabilityContext,
    );

    return null;
  }
}
