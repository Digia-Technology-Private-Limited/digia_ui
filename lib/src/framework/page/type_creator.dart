import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/variable_def.dart';
import '../expr/default_scope_context.dart';
import '../expr/expression_util.dart';
import '../internal_widgets/async_builder/controller.dart';
import '../internal_widgets/timer/controller.dart';

class TypeCreator {
  // Static instance to hold the resolvePageArgs
  static DefaultScopeContext? _resolvePageArgs;

  // Method to initialize resolvePageArgs
  static void initialize(Map<String, Object?>? resolvePageArgs) {
    _resolvePageArgs = resolvePageArgs == null || resolvePageArgs.isEmpty
        ? null
        : DefaultScopeContext(variables: {...resolvePageArgs});
  }

  // Static create method that uses the static instance variable
  static Object? create(VariableDef? def) {
    if (def == null) {
      return null;
    }
    switch (def.type) {
      case 'string':
      case 'number':
      case 'json':
      case 'list':
      case 'boolean':
        return _evaluate(def.defaultValue);

      case 'scrollController':
        return ScrollController();

      case 'timerController':
        final defaultValueMap = def.defaultValue as Map<String, Object?>?;
        return TimerController(
          initialValue: _evaluate(defaultValueMap?['initialValue']),
          updateInterval: _evaluate(defaultValueMap?['updateInterval']),
          isCountDown: _evaluate(defaultValueMap?['isCountDown']),
          duration: _evaluate(defaultValueMap?['duration']),
        );
      case 'streamController':
        return StreamController();
      // case 'tabController':
      //   final defaultValueMap = def.defaultValue as Map<String, Object?>?;
      //   return TabViewController(
      //       initialIndex: _evaluate(defaultValueMap?['initialIndex']) ?? 0,
      //       tabs: _evaluate(defaultValueMap?['dynamicList']) ?? [],
      //       vsync: vsync);
      case 'asyncController':
        return AsyncController();
      case 'textFieldController':
        final defaultValueMap = def.defaultValue as Map<String, Object?>?;
        return TextEditingController(text: _evaluate(defaultValueMap?['text']));

      default:
        throw Exception('Unknown type: ${def.type}');
    }
  }

  // Private static method to evaluate expressions
  static _evaluate(Object? object) {
    return evaluateNestedExpressions(
      object,
      _resolvePageArgs,
    );
  }
}
