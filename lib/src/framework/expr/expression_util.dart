import 'package:digia_expr/digia_expr.dart';

import '../../../digia_ui.dart';
import '../utils/object_util.dart';
import '../utils/types.dart';
import 'scope_context.dart';

/// Evaluates a string expression and converts the result to the specified type.
///
/// This function assumes that the input has already been validated and is a
/// valid string expression. It evaluates the expression using the provided
/// context and attempts to convert the result to type T.
///
/// [expression] The string expression to evaluate.
/// [scopeContext] The context for expression evaluation.
/// Returns the evaluated result converted to type T, or null if conversion fails.
T? evaluateExpression<T extends Object>(
  String expression,
  ScopeContext? scopeContext,
) {
  try {
    return Expression.eval(expression, scopeContext)?.to<T>();
  } catch (error) {
    var errorString = '<!-- $error --!>';
    if (DigiaUIClient.instance.developerConfig?.host is DashboardHost) {
      DigiaUIClient.instance.developerConfig?.logger?.logError(
          error: error.toString(), metaData: {'expression': expression});
      return errorString.to<T>();
    } else {
      rethrow;
    }
  }
}

T? evaluate<T extends Object>(
  Object? expression, {
  ScopeContext? scopeContext,
  T? Function(Object?)? decoder,
}) {
  if (expression == null) return null;

  if (!hasExpression(expression)) {
    return decoder?.call(expression) ?? expression.to<T>();
  }
  try {
    return Expression.eval(expression as String, scopeContext)?.to<T>();
  } catch (error) {
    var errorString = '<!-- $error --!>';
    if (DigiaUIClient.instance.developerConfig?.host is DashboardHost) {
      DigiaUIClient.instance.developerConfig?.logger?.logError(
          error: error.toString(), metaData: {'expression': expression});
      return errorString.to<T>();
    } else {
      rethrow;
    }
  }
}

bool hasExpression(Object? expression) {
  return expression is String && Expression.hasExpression(expression);
}

Object? evaluateNestedExpressions(Object? data, ScopeContext? context) {
  if (data == null) return null;

  // Evaluate primitive types directly
  if (data is String || data is num || data is bool) {
    return evaluate(data, scopeContext: context);
  }

  // Recursively evaluate Map entries
  if (data is Map<String, Object?>) {
    return data.map((key, value) {
      var evaluatedKey = evaluate<String>(key, scopeContext: context) ?? key;
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
