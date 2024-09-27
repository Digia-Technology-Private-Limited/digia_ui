import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../base/processor.dart';
import 'action.dart';

class DelayProcessor implements ActionProcessor<DelayAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    DelayAction action,
    ExprContext? exprContext,
  ) async {
    final durationInMs = action.durationInMs?.evaluate(exprContext);

    if (durationInMs != null) {
      await Future.delayed(Duration(milliseconds: durationInMs));
    } else {
      // log('Wait Duration is null');
    }

    return null;
  }
}
