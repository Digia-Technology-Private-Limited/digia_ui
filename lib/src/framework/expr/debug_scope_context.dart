import 'package:digia_expr/digia_expr.dart';

import 'scope_context.dart';

/// A wrapper context that logs all variable access during expression evaluation
class DebugScopeContext extends ScopeContext {
  final ScopeContext _wrapped;
  final Map<String, dynamic> _accessedVariables = {};
  final List<String> _accessPath = [];

  DebugScopeContext(this._wrapped);

  @override
  String get name => _wrapped.name;

  @override
  ExprContext? get enclosing => _wrapped.enclosing;

  @override
  set enclosing(ExprContext? context) => _wrapped.enclosing = context;

  @override
  ({bool found, Object? value}) getValue(String key) {
    final result = _wrapped.getValue(key);

    if (result.found) {
      // Track the accessed variable and its value
      _accessedVariables[key] = result.value;
      _accessPath.add(key);
    }

    return result;
  }

  @override
  ScopeContext copyAndExtend({required Map<String, Object?> newVariables}) {
    return DebugScopeContext(
      _wrapped.copyAndExtend(newVariables: newVariables),
    );
  }

  Map<String, dynamic> get accessedVariables =>
      Map.unmodifiable(_accessedVariables);
  List<String> get accessPath => List.unmodifiable(_accessPath);
}
