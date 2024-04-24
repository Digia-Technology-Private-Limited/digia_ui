import 'package:digia_expr/digia_expr.dart';
import 'package:digia_ui/src/Utils/extensions.dart';
import 'package:flutter/material.dart';

import '../models/variable_def.dart';
import '../types.dart';

class DUIWidgetScope extends InheritedWidget {
  final DUIIconDataProvider? iconDataProvider;
  final DUIImageProviderFn? imageProviderFn;
  final DUITextStyleBuilder? textStyleBuilder;
  final DUIExternalFunctionHandler? externalFunctionHandler;
  final Map<String, VariableDef>? pageVars;
  final ExprContext? enclosing;

  const DUIWidgetScope({
    super.key,
    this.iconDataProvider,
    this.imageProviderFn,
    this.textStyleBuilder,
    this.externalFunctionHandler,
    this.pageVars,
    this.enclosing,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant DUIWidgetScope oldWidget) {
    return false;
  }

  static DUIWidgetScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DUIWidgetScope>();
  }

  T? eval<T extends Object>(Object? expression,
      [T? Function(dynamic)? fromJsonT]) {
    if (expression == null) return null;

    if (!_hasExpression(expression)) {
      return fromJsonT?.call(expression) ?? expression.typedValue<T>();
    }

    final variables = pageVars?.map((k, v) => MapEntry(k, v.value));

    return Expression.eval(expression as String,
            ExprContext(variables: variables ?? {}, enclosing: enclosing))
        ?.typedValue<T>();
  }
}

bool _hasExpression(dynamic expression) {
  if (expression == null) return false;

  if (expression is! String) return false;

  return Expression.hasExpression(expression);
}
