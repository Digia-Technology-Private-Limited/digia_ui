import 'package:flutter/material.dart';

import '../../expr/scope_context.dart';
import '../base/processor.dart';
import 'action.dart';

class ControlDrawerProcessor extends ActionProcessor<ControlDrawerAction> {
  ControlDrawerProcessor({super.logger});

  @override
  Future<Object?>? execute(
    BuildContext context,
    ControlDrawerAction action,
    ScopeContext? scopeContext,
  ) async {
    final choice = action.choice?.evaluate(scopeContext);
    final scaffold = Scaffold.maybeOf(context);

    logger?.logAction(
      entitySlug: scopeContext!.name,
      actionType: action.actionType.value,
      actionData: {
        'choice': choice,
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

    return null;
  }
}
