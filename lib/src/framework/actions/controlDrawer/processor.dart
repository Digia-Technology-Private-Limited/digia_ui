import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/material.dart';

import '../../expr/scope_context.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class ControlDrawerProcessor extends ActionProcessor<ControlDrawerAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    ControlDrawerAction action,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final choice = action.choice?.evaluate(scopeContext);
    final scaffold = Scaffold.maybeOf(context);

    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'choice': choice,
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
        'choice': choice,
        'scaffoldFound': scaffold != null,
      },
      observabilityContext: observabilityContext,
    );

    Object? error;
    StackTrace? stackTrace;
    try {
      switch (choice) {
        case 'openDrawer':
          scaffold?.openDrawer();
          break;
        case 'openEndDrawer':
          scaffold?.openEndDrawer();
          break;
        default:
          // Unknown choice → no-op; instrumentation already recorded details.
          break;
      }
    } catch (e, s) {
      error = e;
      stackTrace = s;
    } finally {
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: error,
        stackTrace: stackTrace,
        observabilityContext: observabilityContext,
      );
    }

    return null;
  }
}
