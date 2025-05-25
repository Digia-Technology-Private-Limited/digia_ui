import 'package:flutter/widgets.dart';

import '../../../config/app_state/global_state.dart';
import '../../expr/scope_context.dart';
import '../base/processor.dart';
import 'action.dart';

class SetAppStateProcessor extends ActionProcessor<SetAppStateAction> {
  SetAppStateProcessor();

  @override
  Future<Object?>? execute(
    BuildContext context,
    SetAppStateAction action,
    ScopeContext? scopeContext,
  ) {
    final updates = action.updates;
    final updatedValues = <String, dynamic>{};

    for (var update in updates) {
      final newValue = update.newValue?.evaluate(scopeContext);
      if (newValue == null) {
        continue;
      }
      DUIAppState().update(update.stateName, newValue);
      updatedValues[update.stateName] = newValue;
    }

    logAction(
      action.actionType.value,
      updatedValues,
    );
    return null;
  }
}
