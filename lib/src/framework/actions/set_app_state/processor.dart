import 'package:digia_inspector_core/digia_inspector_core.dart';
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
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) {
    final updates = action.updates;
    final updatedValues = <String, dynamic>{};

    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'updateCount': updates.length,
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
        'updateCount': updates.length,
        'stateNames': updates.map((u) => u.stateName).toList(),
      },
      observabilityContext: observabilityContext,
    );

    final updateErrors = <Map<String, Object?>>[];

    try {
      for (var update in updates) {
        try {
          final newValue = update.newValue?.evaluate(scopeContext);
          if (newValue == null) continue;
          DUIAppState().update(update.stateName, newValue);
          updatedValues[update.stateName] = newValue;
        } catch (e, st) {
          updateErrors.add({
            'stateName': update.stateName,
            'error': e.toString(),
            'stackTrace': st.toString(),
          });
        }
      }

      executionContext?.notifyProgress(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        details: {
          'stage': 'state_updated',
          'updatedValues': updatedValues,
          'updatedCount': updatedValues.length,
          if (updateErrors.isNotEmpty) 'updateErrors': updateErrors,
        },
        observabilityContext: observabilityContext,
      );

      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: null,
        stackTrace: null,
        observabilityContext: observabilityContext,
      );
    } catch (e, st) {
      // Capture unexpected top-level errors
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: e,
        stackTrace: st,
        observabilityContext: observabilityContext,
      );
      rethrow;
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
