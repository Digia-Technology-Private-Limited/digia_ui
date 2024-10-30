import 'package:flutter/material.dart';

import '../../expr/scope_context.dart';
import '../base/processor.dart';
import 'action.dart';

class NavigateBackUntilProcessor
    extends ActionProcessor<NavigateBackUntilAction> {
  NavigateBackUntilProcessor({super.logger});

  @override
  Future<Object?>? execute(
    BuildContext context,
    NavigateBackUntilAction action,
    ScopeContext? scopeContext,
  ) async {
    final routeNameToPopUntil =
        action.routeNameToPopUntil?.evaluate(scopeContext);

    logger?.logAction(
      entitySlug: scopeContext!.name,
      actionType: action.actionType.value,
      actionData: {
        'routeNameToPopUntil': routeNameToPopUntil,
      },
    );

    if (routeNameToPopUntil == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.popUntil(context, ModalRoute.withName(routeNameToPopUntil));
    }

    return null;
  }
}
