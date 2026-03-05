import 'dart:async';

import 'base.dart';
import 'register_bindings.dart';

class MethodBindingRegistry {
  final Map<Type, Map<String, MethodCommand>> _bindings = {};

  MethodBindingRegistry() {
    registerBindings(this);
  }

  // Registers a command for a given method name
  void registerMethods<T>(Map<String, MethodCommand<T>> commands) {
    _bindings[T] = commands;
  }

  // Executes the command by name, passing the instance and arguments
  void execute<T>(T instance, String methodName, Map<String, Object?> args) {
    Type lookupType = instance.runtimeType;

    // StreamController.broadcast() returns _AsyncBroadcastStreamController (dart:async impl detail).
    if (!_bindings.containsKey(lookupType) &&
        instance is StreamController<Object?>) {
      lookupType = StreamController<Object?>;
    }

    if (_bindings.containsKey(lookupType) &&
        _bindings[lookupType]!.containsKey(methodName)) {
      final command = _bindings[lookupType]![methodName];
      command?.run(instance, args);
      return;
    }

    throw Exception(
        'Method $methodName not found on instance of type: ${instance.runtimeType}');
  }

  void dispose() {
    _bindings.clear();
  }
}
