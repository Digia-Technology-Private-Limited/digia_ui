import 'dart:async';

import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../../internal_widgets/timer/controller.dart';
import 'base.dart';
import 'scroll_controller_adaptor.dart';
import 'stream_controller_adaptor.dart';
import 'text_field_controller_adapter.dart';
import 'timer_controller_adaptor.dart';

class AdapterRegistry {
  static final AdapterRegistry _instance = AdapterRegistry._internal();
  factory AdapterRegistry() => _instance;
  AdapterRegistry._internal() {
    registerAdapter<ScrollController>(ScrollControllerAdapter());
    registerAdapter<StreamController>(StreamControllerAdapter());
    registerAdapter<TextEditingController>(TextEditingControllerAdapter());
    registerAdapter<TimerController>(TimerControllerAdaptor());
  }

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
