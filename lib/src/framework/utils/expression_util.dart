import 'package:digia_expr/digia_expr.dart';

import 'object_util.dart';

T? evaluate<T extends Object>(
  Object? expression, {
  ExprContext? exprContext,
  T? Function(Object?)? decoder,
}) {
  if (expression == null) return null;

  if (!hasExpression(expression)) {
    return decoder?.call(expression) ?? expression.to<T>();
  }

  return Expression.eval(expression as String, exprContext)?.to<T>();
}

bool hasExpression(dynamic expression) {
  return expression is String && Expression.hasExpression(expression);
}

Object? evaluateNestedExpressions(Object? data, ExprContext? context) {
  if (data == null) return null;

  // Evaluate primitive types directly
  if (data is String || data is num || data is bool) {
    return evaluate(data, exprContext: context);
  }

  // Recursively evaluate Map entries
  if (data is Map<String, Object?>) {
    return data.map((key, value) {
      var evaluatedKey =
          hasExpression(key) ? evaluate(key, exprContext: context) : key;
      var evaluatedValue = evaluateNestedExpressions(value, context);
      return MapEntry(evaluatedKey, evaluatedValue);
    });
  }

  // Recursively evaluate List elements
  if (data is List) {
    return data.map((e) => evaluateNestedExpressions(e, context)).toList();
  }

  // Return unchanged for unsupported types
  return data;
}
