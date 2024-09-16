import 'package:digia_expr/digia_expr.dart';

typedef ExpressionEvaluatorFn<T extends Object> = T? Function(
  Object? expression, {
  ExprContext? exprContext,
  T? Function(Object?)? decoder,
});
