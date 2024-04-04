import 'dart:convert';

import 'package:digia_expr/digia_expr.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:flutter/material.dart';

import '../components/dui_widget.dart';
import 'basic_shared_utils/num_decoder.dart';

bool _hasExpression(dynamic expression) {
  if (expression == null) return false;

  if (expression is! String) return false;

  return Expression.hasExpression(expression);
}

T? evaluateExpression<T extends Object>(
    dynamic expression, BuildContext context, T? Function(String) fromJsonT) {
  if (expression == null) return null;

  if (!_hasExpression(expression)) return fromJsonT(expression);

  final variables = DUIWidgetScope.of(context)?.pageVars;

  return Expression.eval(
          expression,
          ExprContext(
              variables: variables?.map((key, value) => MapEntry(key, () {
                        switch (value.type) {
                          case 'string':
                            return ASTStringLiteral(
                                value: value.value?.toString());

                          case 'integer':
                            return ASTNumberLiteral(
                                value: NumDecoder.toInt(value.value));

                          case 'float':
                            return ASTNumberLiteral(
                                value: NumDecoder.toDouble(value.value));
                        }
                        return ASTStringLiteral();
                      }())) ??
                  {}))
      .typedValue<T>();
}

extension ObjectExt on Object? {
  R? typedValue<R extends Object>({R? defaultValue}) {
    final value = this;
    if (this == null) return defaultValue;
    if (value is R) return value;

    return switch (R) {
      const (String) =>
        (value is List || value is Map ? jsonEncode(value) : value.toString())
                .tryCast<R>() ??
            defaultValue,
      const (int) => NumDecoder.toInt(value).tryCast<R>() ?? defaultValue,
      const (double) => NumDecoder.toDouble(value).tryCast<R>() ?? defaultValue,
      const (bool) => NumDecoder.toBool(value).tryCast()<R>() ?? defaultValue,
      _ => defaultValue
    };
  }
}
