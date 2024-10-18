import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../expr/expression_util.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/async_builder/controller.dart';
import '../internal_widgets/timer/controller.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';
import 'data_type.dart';
import 'variable.dart';

class DataTypeCreator {
  // Static create method that uses the static instance variable
  static Object? create(
    Variable def, {
    ScopeContext? scopeContext,
  }) {
    switch (def.type) {
      case DataType.string:
      case DataType.number:
      case DataType.boolean:
        return evaluate<Object>(def.defaultValue, scopeContext: scopeContext);

      case DataType.json:
      case DataType.jsonArray:
        return evaluateNestedExpressions(def.defaultValue, scopeContext);

      case DataType.scrollController:
        return ScrollController();

      case DataType.streamController:
        return StreamController<Object?>();

      case DataType.asyncController:
        return AsyncController<Object?>();

      case DataType.textEditingController:
        final value = as$<JsonLike>(def.defaultValue) ?? {};
        return TextEditingController(
          text: evaluate<String>(value['text'], scopeContext: scopeContext),
        );

      case DataType.timerController:
        final value = as$<JsonLike>(def.defaultValue) ?? {};
        return TimerController(
          initialValue: evaluate<int>(value['initialValue'],
                  scopeContext: scopeContext) ??
              0,
          updateInterval:
              Duration(seconds: evaluate<int>(value['updateInterval']) ?? 1),
          isCountDown: value['timerType'] == 'countDown',
          duration: evaluate<int>(value['duration']) ?? 0,
        );

      default:
        throw Exception('Unknown type: ${def.type}');
    }
  }
}
