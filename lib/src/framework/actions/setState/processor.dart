import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import '../../state/state_context_provider.dart';
import '../base/processor.dart';
import 'action.dart';

class SetStateProcessor extends ActionProcessor<SetStateAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    SetStateAction action,
    ScopeContext? scopeContext,
  ) async {
    final stateContext =
        StateContextProvider.findStateByName(context, action.stateContextName);
    if (stateContext == null) {
      throw 'Action.setState called on a widget which is not wrapped in StateContextProvider';
    }

    final updates = action.updates;
    final rebuildPage = action.rebuild?.evaluate(scopeContext) ?? false;

    if (updates.isNotEmpty) {
      final updatesMap = Map.fromEntries(updates.map(
        (update) =>
            MapEntry(update.stateName, update.newValue?.evaluate(scopeContext)),
      ));
      logAction(
        action.actionType.value,
        {
          'stateContextName': action.stateContextName,
          'rebuild': rebuildPage,
          ...updatesMap,
        },
      );
      stateContext.setValues(updatesMap, notify: rebuildPage);
    }

    return null;
  }
}
