import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/material.dart';

import '../../expr/scope_context.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class NavigateBackUntilProcessor
    extends ActionProcessor<NavigateBackUntilAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    NavigateBackUntilAction action,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final routeNameToPopUntil =
        action.routeNameToPopUntil?.evaluate(scopeContext);

    final actionDescriptor = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'routeNameToPopUntil': routeNameToPopUntil,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: actionDescriptor,
      observabilityContext: observabilityContext,
    );

    executionContext?.notifyProgress(
      id: id,
      parentActionId: parentActionId,
      descriptor: actionDescriptor,
      details: {
        'routeNameToPopUntil': routeNameToPopUntil,
        'hasRouteName': routeNameToPopUntil != null,
      },
      observabilityContext: observabilityContext,
    );

    if (routeNameToPopUntil == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.popUntil(context, ModalRoute.withName(routeNameToPopUntil));
    }

    executionContext?.notifyComplete(
      id: id,
      parentActionId: parentActionId,
      descriptor: actionDescriptor,
      error: null,
      stackTrace: null,
      observabilityContext: observabilityContext,
    );

    return null;
  }
}
