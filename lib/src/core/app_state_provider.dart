import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../models/variable_def.dart';

class AppStateProvider extends InheritedWidget {
  final Map<String, VariableDef>? state;

  const AppStateProvider({super.key, this.state, required super.child});

  void setState(String name, Object? value) => state?[name]?.set(value);

  Map<String, Object>? get variables => {
        'appState':
            AppStateClass(fields: state?.map((k, v) => MapEntry(k, v.value)))
      };

  static AppStateProvider? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppStateProvider>();

  @override
  bool updateShouldNotify(covariant AppStateProvider oldWidget) => false;
}

// ignore: non_constant_identifier_names
ExprClassInstance AppStateClass(
    {Map<String, Object?>? fields, Map<String, ExprCallable>? methods}) {
  return ExprClassInstance(
      klass: ExprClass(
          name: 'AppState', fields: fields ?? {}, methods: methods ?? {}));
}
