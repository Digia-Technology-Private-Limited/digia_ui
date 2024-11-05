import 'package:flutter/material.dart';

import '../../expr/scope_context.dart';
import '../base/processor.dart';
import 'action.dart';

class NavigateBackUntilProcessor
    implements ActionProcessor<NavigateBackUntilAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    NavigateBackUntilAction action,
    ScopeContext? scopeContext,
  ) async {
    final routeNameToPopUntil =
        action.routeNameToPopUntil?.evaluate(scopeContext);

    if (routeNameToPopUntil == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.popUntil(context, ModalRoute.withName(routeNameToPopUntil));
    }

    return null;
  }
}
