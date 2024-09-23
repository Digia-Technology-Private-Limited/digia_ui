import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import 'action.dart' as an;

abstract class ActionProcessor<T extends an.Action> {
  Future<Object?>? execute(
    BuildContext context,
    T action,
    ExprContext? exprContext,
  );
}
