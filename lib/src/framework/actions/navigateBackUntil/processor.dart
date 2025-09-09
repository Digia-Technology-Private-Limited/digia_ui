import 'package:flutter/material.dart';

import '../../expr/scope_context.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class NavigateBackUntilProcessor
    extends ActionProcessor<NavigateBackUntilAction> {
  @override
  Future<Object?>? execute(BuildContext context, NavigateBackUntilAction action,
      ScopeContext? scopeContext,
      {required String eventId, required String parentId}) async {
    final routeNameToPopUntil =
        action.routeNameToPopUntil?.evaluate(scopeContext);

    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'routeNameToPopUntil': routeNameToPopUntil,
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
        'routeNameToPopUntil': routeNameToPopUntil,
        'hasRouteName': routeNameToPopUntil != null,
      },
    );

    if (routeNameToPopUntil == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.popUntil(context, ModalRoute.withName(routeNameToPopUntil));
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
