import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../base/processor.dart';
import 'action.dart';

class ControlDrawerProcessor implements ActionProcessor<ControlDrawerAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    ControlDrawerAction action,
    ExprContext? exprContext,
  ) async {
    final choice = action.choice?.evaluate(exprContext);
    final scaffold = Scaffold.maybeOf(context);

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
