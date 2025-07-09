import '../expr/expression_util.dart' as expr;
import '../expr/scope_context.dart';
import '../utils/object_util.dart';

typedef ExpressionEvaluatorFn<T extends Object> = T? Function(
  Object? expression, {
  ScopeContext? scopeContext,
  T? Function(Object?)? decoder,
});

class ExprOr<T extends Object> {
  // The underlying value, which can be either a direct value of type T or an expression
  final Object _value;
  // Determines if the value is an expression using a utility function
  final bool isExpr;

  ExprOr(Object value)
      : _value = value,
        isExpr = _isExpression(value);

  // Helper method to determine if a value is an expression
  static bool _isExpression(Object value) {
    if (value is Map<String, dynamic> && value.containsKey('expr')) {
      // New format: {"expr": "expression"}
      return true;
    }
    // Old format: "${expression}" - use existing logic
    return expr.hasExpression(value);
  }

  // Evaluates the value, returning a result of type T
  T? evaluate(
    ScopeContext? scopeContext, {
    T? Function(Object)? decoder,
  }) {
    if (isExpr) {
      String expressionString;

      if (_value is Map<String, dynamic> &&
          (_value as Map<String, dynamic>).containsKey('expr')) {
        // New format: extract expression from map
        expressionString = (_value as Map<String, dynamic>)['expr'] as String;
      } else {
        // Old format: use the value directly as string
        expressionString = _value as String;
      }

      // Evaluate the expression using the expression utility
      return expr.evaluateExpression<T>(expressionString, scopeContext);
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
  /// [scopeContext] The context for expression evaluation.
  ///
  /// Returns the deeply evaluated result.
  Object? deepEvaluate(ScopeContext? scopeContext) {
    if (isExpr) {
      Object valueToEvaluate;

      if (_value is Map<String, dynamic> &&
          (_value as Map<String, dynamic>).containsKey('expr')) {
        // New format: extract expression from map
        valueToEvaluate = (_value as Map<String, dynamic>)['expr'];
      } else {
        // Old format: use the value directly
        valueToEvaluate = _value;
      }

      return expr.evaluateNestedExpressions(valueToEvaluate, scopeContext);
    } else {
      return expr.evaluateNestedExpressions(_value, scopeContext);
    }
  }

  // Creates an ExprOr instance from a JSON representation
  static ExprOr<T>? fromJson<T extends Object>(Object? json) {
    if (json == null) return null;

    // Handle both old and new formats
    if (json is Map<String, dynamic>) {
      if (json.containsKey('expr')) {
        // New format: {"expr": "expression"}
        return ExprOr<T>(json);
      } else {
        // Map without 'expr' key - treat as regular value
        return ExprOr<T>(json);
      }
    }

    // Old format or primitive value
    return ExprOr<T>(json);
  }

  // Converts the ExprOr instance to a JSON-compatible representation
  Object? toJson() => _value;

  @override
  String toString() => 'ExprOr($_value)';
}
