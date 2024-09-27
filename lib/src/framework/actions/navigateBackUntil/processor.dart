import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../base/processor.dart';
import 'action.dart';

class NavigateBackUntilProcessor
    implements ActionProcessor<NavigateBackUntilAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    NavigateBackUntilAction action,
    ExprContext? exprContext,
  ) async {
    final routeNameToPopUntil =
        action.routeNameToPopUntil?.evaluate(exprContext);

    if (routeNameToPopUntil == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.popUntil(context, ModalRoute.withName(routeNameToPopUntil));
    }

    return null;
  }
}
