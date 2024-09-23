import 'package:digia_expr/digia_expr.dart';

import 'object_util.dart';

/// Evaluates a string expression and converts the result to the specified type.
///
/// This function assumes that the input has already been validated and is a
/// valid string expression. It evaluates the expression using the provided
/// context and attempts to convert the result to type T.
///
/// [expression] The string expression to evaluate.
/// [exprContext] The context for expression evaluation.
/// Returns the evaluated result converted to type T, or null if conversion fails.
T? evaluateExpression<T extends Object>(
  String expression,
  ExprContext? exprContext,
) {
  return Expression.eval(expression, exprContext)?.to<T>();
}

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
