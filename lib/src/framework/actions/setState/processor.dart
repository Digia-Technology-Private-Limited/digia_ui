import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import '../../state/state_context_provider.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class SetStateProcessor extends ActionProcessor<SetStateAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    SetStateAction action,
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  }) async {
    final stateContext =
        StateContextProvider.findStateByName(context, action.stateContextName);
    if (stateContext == null) {
      throw 'Action.setState called on a widget which is not wrapped in StateContextProvider';
    }

    final updates = action.updates;
    final rebuildPage = action.rebuild?.evaluate(scopeContext) ?? false;

    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'stateContextName': action.stateContextName,
        'rebuild': rebuildPage,
      },
    );

    executionContext?.notifyStart(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
    );

    if (updates.isNotEmpty) {
      final updatesMap = Map.fromEntries(updates.map(
        (update) =>
            MapEntry(update.stateName, update.newValue?.evaluate(scopeContext)),
      ));

      executionContext?.notifyProgress(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        details: {
          'stateContextName': action.stateContextName,
          'rebuild': rebuildPage,
          ...updatesMap,
        },
      );

      stateContext.setValues(updatesMap, notify: rebuildPage);
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
