import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../../digia_ui.dart';
import '../Utils/extensions.dart';
import 'scoped_values.dart';

T? eval<T extends Object>(Object? expression,
    {required BuildContext context,
    ExprContext? enclosing,
    T? Function(Object?)? decoder}) {
  if (expression == null) return null;

  if (!hasExpression(expression)) {
    return decoder?.call(expression) ?? expression.toType<T>();
  }

  final jsEnv = DigiaUIClient.instance.exprContext;
  jsEnv.enclosing = enclosing;

  final scope = createScope(context);

  scope?.enclosing = jsEnv;

  return Expression.eval(expression as String, scope ?? enclosing)?.toType<T>();
}

bool hasExpression(dynamic expression) {
  if (expression == null) return false;

  if (expression is! String) return false;

  return Expression.hasExpression(expression);
}
