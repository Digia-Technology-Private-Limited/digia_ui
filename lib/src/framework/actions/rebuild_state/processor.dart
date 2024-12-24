import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import '../../state/state_context_provider.dart';
import '../base/processor.dart';
import 'action.dart';

class RebuildStateProcessor extends ActionProcessor<RebuildStateAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    RebuildStateAction action,
    ScopeContext? scopeContext,
  ) {
    logAction(
      action.actionType.value,
      {
        'stateContextName': action.stateContextName,
      },
    );

    if (action.stateContextName == null) {
      final originState = StateContextProvider.getOriginState(context);
      originState.triggerListeners();
      return null;
    }

    final stateContext =
        StateContextProvider.findStateByName(context, action.stateContextName!);
    stateContext?.triggerListeners();
    return null;
  }
}
