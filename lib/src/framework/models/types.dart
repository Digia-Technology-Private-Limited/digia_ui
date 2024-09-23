import 'package:digia_expr/digia_expr.dart';

import '../utils/expression_util.dart' as expr;
import '../utils/object_util.dart';

typedef ExpressionEvaluatorFn<T extends Object> = T? Function(
  Object? expression, {
  ExprContext? exprContext,
  T? Function(Object?)? decoder,
});

class ExprOr<T extends Object> {
  // The underlying value, which can be either a direct value of type T or an expression
  final Object _value;
  // Determines if the value is an expression using a utility function
  final bool isExpr;

  ExprOr(Object value)
      : _value = value,
        isExpr = expr.hasExpression(value);

  // Evaluates the value, returning a result of type T
  T? evaluate(
    ExprContext? exprContext, {
    T? Function(Object)? decoder,
  }) {
    if (isExpr) {
      // If it's an expression, evaluate it using the expression utility
      return expr.evaluateExpression<T>(_value as String, exprContext);
    } else {
      // If it's not an expression, cast it to T
      return decoder?.call(_value) ?? _value.to<T>();
    }
  }

  /// Evaluates the value deeply, resolving nested expressions.
  ///
  /// This method performs a deep evaluation of the value, resolving any nested
  /// expressions within complex data structures like maps and lists.
  ///
  /// [exprContext] The context for expression evaluation.
  ///
  /// Returns the deeply evaluated result.
  Object? deepEvaluate(ExprContext? exprContext) {
    if (isExpr) {
      return expr.evaluateNestedExpressions(_value, exprContext);
    } else {
      return _value;
    }
  }

  // Creates an ExprOr instance from a JSON representation
  static ExprOr<T>? fromJson<T extends Object>(dynamic json) {
    if (json == null) return null;
    return ExprOr<T>(json as Object);
  }

  // Converts the ExprOr instance to a JSON-compatible representation
  dynamic toJson() => _value;

  @override
  String toString() => 'ExprOr($_value)';
}
