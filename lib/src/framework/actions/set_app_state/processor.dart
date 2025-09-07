import 'package:flutter/widgets.dart';

import '../../../config/app_state/global_state.dart';
import '../../expr/scope_context.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class SetAppStateProcessor extends ActionProcessor<SetAppStateAction> {
  SetAppStateProcessor();

  @override
  Future<Object?>? execute(
    BuildContext context,
    SetAppStateAction action,
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  }) {
    final updates = action.updates;
    final updatedValues = <String, dynamic>{};

    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'updateCount': updates.length,
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
        'updateCount': updates.length,
        'stateNames': updates.map((u) => u.stateName).toList(),
      },
    );

    for (var update in updates) {
      final newValue = update.newValue?.evaluate(scopeContext);
      if (newValue == null) {
        continue;
      }
      DUIAppState().update(update.stateName, newValue);
      updatedValues[update.stateName] = newValue;
    }

    executionContext?.notifyProgress(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
      details: {
        'stage': 'state_updated',
        'updatedValues': updatedValues,
        'updatedCount': updatedValues.length,
      },
    );

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
