import 'package:digia_expr/digia_expr.dart';
import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/num_decoder.dart';
import 'package:flutter/material.dart';

import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/DUIText/dui_text_style.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';

class DUIText2Builder extends DUIWidgetBuilder {
  DUIText2Builder({required super.data});

  static DUIText2Builder? create(DUIWidgetJsonData data) {
    return DUIText2Builder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final text = ExpressionOr<String>.parse(data.props['text']);
    final style = toTextStyle(DUITextStyle.fromJson(data.props['textStyle']));
    final maxLines = data.props['maxLines'] as int?;
    final overflow = DUIDecoder.toTextOverflow(data.props['overflow']);
    final textAlign = DUIDecoder.toTextAlign(data.props['textAlign']);

    return Text(text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign);
  }
}

const stringExpressionRegex = r'\$\{\s{0,}(.+)\s{0,}\}';

T? evaluateExpression<T>(
    String expression, BuildContext context, T? Function(String) fromJsonT) {
  if (RegExp(stringExpressionRegex).hasMatch(expression)) {
    final variables = DUIWidgetScope.of(context)?.pageVars;

    final root = createAST(expression);

    return ASTEvaluator().eval(
        root,
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
                      return ASTIdentifer(name: 'null');
                    }())) ??
                {})) as T;
  }

  return fromJsonT(expression);
}

extension ObjectExt on Object? {
  R? tryCast<R extends Object>({R? defaultValue}) {
    final value = this;
    if (this == null) return defaultValue;
    if (value is R) return value;

    return switch (R) {
      const (String) =>
        (value is List || value is Map ? jsonEncode(value) : value.toString())
            .tryCast<R>(),
      const (int) => value.toInt().tryCast<R>() ?? defaultValue,
      const (double) => value.toDouble().tryCast<R>() ?? defaultValue,
      const (num) => value.toNum().tryCast<R>() ?? defaultValue,
      const (bool) => value.toBool().tryCast<R>() ?? defaultValue,
      _ => defaultValue,
    };
  }
}
