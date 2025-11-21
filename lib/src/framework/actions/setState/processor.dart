import 'package:digia_inspector_core/digia_inspector_core.dart';
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
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final stateContext =
        StateContextProvider.findStateByName(context, action.stateContextName);
    if (stateContext == null) {
      throw 'Action.setState called on a widget which is not wrapped in StateContextProvider';
    }

    final updates = action.updates;
    final rebuildPage = action.rebuild?.evaluate(scopeContext) ?? false;

    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'stateContextName': action.stateContextName,
        'rebuild': rebuildPage,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      observabilityContext: observabilityContext,
    );

    if (updates.isNotEmpty) {
      final updatesMap = Map.fromEntries(updates.map(
        (update) => MapEntry(
            update.stateName, update.newValue?.deepEvaluate(scopeContext)),
      ));

      executionContext?.notifyProgress(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        details: {
          'stateContextName': action.stateContextName,
          'rebuild': rebuildPage,
          ...updatesMap,
        },
        observabilityContext: observabilityContext,
      );

      stateContext.setValues(updatesMap, notify: rebuildPage);
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
