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
    required String eventId,
    required String parentId,
  }) async {
    final choice = action.choice?.evaluate(scopeContext);
    final scaffold = Scaffold.maybeOf(context);

    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'choice': choice,
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
        'choice': choice,
        'scaffoldFound': scaffold != null,
      },
    );

    switch (choice) {
      case 'openDrawer':
        scaffold?.openDrawer();
        break;

      case 'openEndDrawer':
        scaffold?.openEndDrawer();
        break;

      default:
        scaffold?.closeDrawer();
        scaffold?.closeEndDrawer();
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
