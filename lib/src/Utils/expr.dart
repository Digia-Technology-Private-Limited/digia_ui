
import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../core/evaluator.dart';

evalDynamic(dynamic pageArgs, BuildContext context, ExprContext? enclosing) {
  if (pageArgs == null) return null;

  if (pageArgs is String || pageArgs is num || pageArgs is bool) {
    return eval(pageArgs, context: context, enclosing: enclosing);
  }

  if (pageArgs is Map<String, dynamic>) {
    return pageArgs
        .map((key, value) => MapEntry(key, evalDynamic(value, context, enclosing)));
  }

  if (pageArgs is List) {
    return pageArgs.map((e) => evalDynamic(e, context, enclosing));
  }

  return null;
}