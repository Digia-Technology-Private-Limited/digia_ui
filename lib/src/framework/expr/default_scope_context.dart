import 'package:digia_expr/src/expr_context.dart';

import '../data_type/adaptors/adaptor_registry.dart';

import 'scope_context.dart';

/// A basic implementation of ExprContext that can be used as-is or extended.
class DefaultScopeContext extends ScopeContext {
  @override
  final String name;

  ExprContext? _enclosing;
  final Map<String, Object?> _variables;

  final AdapterRegistry _adaptor = AdapterRegistry();

  DefaultScopeContext({
    this.name = '',
    required Map<String, Object?> variables,
    ExprContext? enclosing,
  })  : _variables = Map.from(variables),
        _enclosing = enclosing;

  @override
  set enclosing(ExprContext? context) {
    _enclosing = context;
  }

  @override
  ExprContext? get enclosing => _enclosing;

  @override
  ({bool found, Object? value}) getValue(String key) {
    if (_variables.containsKey(key)) {
      return (
        found: true,
        value: adaptValue(_variables[key]),
      );
    }
    return _enclosing?.getValue(key) ?? (found: false, value: null);
  }

  Object? adaptValue(Object? value) {
    if (value == null) return null;

    return _adaptor.adaptValue(value) ?? value;
  }

  @override
  ScopeContext copyAndExtend({required Map<String, Object?> newVariables}) {
    return DefaultScopeContext(
      name: name,
      variables: Map.from(_variables)..addAll(newVariables),
      enclosing: _enclosing,
    );
  }
}
