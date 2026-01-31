import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import '../../state/state_context_provider.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class RebuildStateProcessor extends ActionProcessor<RebuildStateAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    RebuildStateAction action,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) {
    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'stateContextName': action.stateContextName,
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
        'stateContextName': action.stateContextName,
        'hasStateContextName': action.stateContextName != null,
      },
      observabilityContext: observabilityContext,
    );

    if (action.stateContextName == null) {
      final originState = StateContextProvider.getOriginState(context);
      originState.triggerListeners();
    } else {
      final stateContext = StateContextProvider.findStateByName(
          context, action.stateContextName!);
      stateContext?.triggerListeners();
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
