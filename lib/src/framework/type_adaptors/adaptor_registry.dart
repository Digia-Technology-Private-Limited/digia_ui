import 'package:digia_expr/digia_expr.dart';

import 'base.dart';

class AdapterRegistry {
  static final AdapterRegistry _instance = AdapterRegistry._internal();
  factory AdapterRegistry() => _instance;
  AdapterRegistry._internal();

  final Map<Type, TypeAdapter> _adapterMap = {};

  void registerAdapter<T>(TypeAdapter<T> adapter) {
    _adapterMap[T] = adapter;
  }

  ExprClassInstance? adaptValue(Object? value) {
    if (value == null) return null;

    final adapter = _adapterMap[value.runtimeType];
    if (adapter != null && adapter.canAdapt(value)) {
      return adapter.wrap(value);
    }

    return null;
  }
}
