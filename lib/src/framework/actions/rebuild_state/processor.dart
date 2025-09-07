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
    required String eventId,
    required String parentId,
  }) {
    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'stateContextName': action.stateContextName,
      },
    );

    executionContext?.notifyStart(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
    );

    executionContext?.notifyProgress(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
      details: {
        'stateContextName': action.stateContextName,
        'hasStateContextName': action.stateContextName != null,
      },
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
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
      error: null,
      stackTrace: null,
    );

    return null;
  }
}
