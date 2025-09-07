import 'package:flutter/material.dart';

import '../../expr/scope_context.dart';
import '../../internal_widgets/inherited_scaffold_controller.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class ControlNavBarProcessor extends ActionProcessor<ControlNavBarAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    ControlNavBarAction action,
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  }) async {
    final index = action.index?.evaluate(scopeContext);
    final navController = InheritedScaffoldController.maybeOf(context);

    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'index': index,
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
        'index': index,
        'navControllerFound': navController != null,
        'indexIsInt': index is int,
      },
    );

    if (navController != null && index is int) {
      navController.setCurrentIndex(index);
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
