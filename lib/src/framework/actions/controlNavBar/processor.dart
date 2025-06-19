import 'package:flutter/material.dart';

import '../../expr/scope_context.dart';
import '../../internal_widgets/inherited_scaffold_controller.dart';
import '../base/processor.dart';
import 'action.dart';

class ControlNavBarProcessor extends ActionProcessor<ControlNavBarAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    ControlNavBarAction action,
    ScopeContext? scopeContext,
  ) async {
    final index = action.index?.evaluate(scopeContext);
    final navController = InheritedScaffoldController.maybeOf(context);

    logAction(
      action.actionType.value,
      {
        'index': index,
      },
    );

    if (navController != null && index is int) {
      navController.setCurrentIndex(index);
    }

    return null;
  }
}
