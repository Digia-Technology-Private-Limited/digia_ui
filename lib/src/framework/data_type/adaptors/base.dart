import 'package:digia_expr/digia_expr.dart';

abstract class TypeAdapter<T> {
  ExprClassInstance wrap(T value);
  bool canAdapt(Object? value);
}
