import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../Utils/extensions.dart';
import '../components/dui_widget_scope.dart';
import 'models/vw_repeat_data.dart';

class RenderPayload {
  final BuildContext buildContext;
  final ExprContext exprContext;

  RenderPayload({required this.buildContext, required this.exprContext});

  IconData? getIcon(Map<String, Object?>? map) {
    if (map == null) return null;

    // TODO: Can we think of something better here?
    final scope = DUIWidgetScope.maybeOf(buildContext);

    return scope?.iconDataProvider?.call(map);
  }

// Evaluates an expression with an optional chained exprContext
  T? eval<T extends Object>(Object? expression,
      {ExprContext? exprContext, T? Function(Object?)? decoder}) {
    return evaluate<T>(expression,
        exprContext: _chainExprContext(exprContext), decoder: decoder);
  }

  // Evaluates and retrieves repeatable data
  List<Object> evalRepeatData(VWRepeatData data) {
    if (data.isJson) {
      return data.toJsonArray() ?? [];
    }

    return eval<List>(
          data.datum,
          decoder: (p0) => p0 as List?,
        )?.cast<Object>() ??
        [];
  }

// Chains the incoming exprContext with the existing one
  ExprContext _chainExprContext(ExprContext? incoming) {
    return _createChain(exprContext, incoming);
  }

  // Creates the exprContext chain
  ExprContext _createChain(ExprContext enclosing, ExprContext? exprContext) {
    if (exprContext == null) return enclosing;

    return exprContext..appendEnclosing(enclosing);
  }

  // Copies the payload with a new exprContext, chaining it with the current one
  RenderPayload copyWithChainedContext(
    ExprContext exprContext, {
    BuildContext? buildContext,
  }) {
    return copyWith(
      buildContext: buildContext ?? this.buildContext,
      exprContext: _chainExprContext(exprContext),
    );
  }

  RenderPayload copyWith({
    BuildContext? buildContext,
    ExprContext? exprContext,
  }) {
    return RenderPayload(
      buildContext: buildContext ?? this.buildContext,
      exprContext: exprContext ?? this.exprContext,
    );
  }
}

T? evaluate<T extends Object>(Object? expression,
    {ExprContext? exprContext, T? Function(Object?)? decoder}) {
  if (expression == null) return null;

  if (!hasExpression(expression)) {
    return decoder?.call(expression) ?? expression.toType<T>();
  }

  return Expression.eval(expression as String, exprContext)?.toType<T>();
}

bool hasExpression(dynamic expression) {
  if (expression == null) return false;

  if (expression is! String) return false;

  return Expression.hasExpression(expression);
}
