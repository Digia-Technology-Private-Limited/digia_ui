import 'package:digia_inspector_core/digia_inspector_core.dart';
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
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final index = action.index?.evaluate(scopeContext);
    final navController = InheritedScaffoldController.maybeOf(context);

    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'index': index,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      observabilityContext: observabilityContext,
    );
    try {
      executionContext?.notifyProgress(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        details: {
          'index': index,
          'navControllerFound': navController != null,
          'indexIsInt': index is int,
        },
        observabilityContext: observabilityContext,
      );

      if (navController != null && index is int) {
        navController.setCurrentIndex(index);
      }
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: null,
        stackTrace: null,
        observabilityContext: observabilityContext,
      );
    } catch (e, st) {
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

    return null;
  }
}
