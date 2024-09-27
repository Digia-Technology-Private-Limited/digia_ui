import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../base/processor.dart';
import 'action.dart';

class NavigateBackProcessor implements ActionProcessor<NavigateBackAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    NavigateBackAction action,
    ExprContext? exprContext,
  ) async {
    final maybe = action.maybe?.evaluate(exprContext) ?? false;
    final result = action.result?.deepEvaluate(exprContext);

    if (maybe) {
      return Navigator.of(context).maybePop(result);
    } else {
      Navigator.of(context).pop(result);
      return null;
    }
  }
}
