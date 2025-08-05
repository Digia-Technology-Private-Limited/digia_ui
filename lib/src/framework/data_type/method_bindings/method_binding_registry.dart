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
    if (_bindings.containsKey(instance.runtimeType) &&
        _bindings[instance.runtimeType]!.containsKey(methodName)) {
      final command = _bindings[instance.runtimeType]![methodName];
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
