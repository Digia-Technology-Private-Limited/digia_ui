import 'base.dart';
import 'register_bindings.dart';

class MethodBindingRegistry {
  final List<(bool Function(Object?), Map<String, MethodCommand>)>
      _typeCheckers = [];

  MethodBindingRegistry() {
    registerBindings(this);
  }

  // Registers a command for a given method name
  void registerMethods<T>(Map<String, MethodCommand<T>> commands) {
    _typeCheckers.add(((instance) => instance is T, commands));
  }

  // Executes the command by name, passing the instance and arguments
  void execute<T>(T instance, String methodName, Map<String, Object?> args) {
    // Use is-based type checkers to support both exact types and subtypes.
    // This handles cases like _AsyncBroadcastStreamController, which is a
    // subtype of StreamController<Object?> but has a different runtimeType.
    for (final (checker, commands) in _typeCheckers) {
      if (checker(instance) && commands.containsKey(methodName)) {
        commands[methodName]?.run(instance, args);
        return;
      }
    }

    throw Exception(
        'Method $methodName not found on instance of type: ${instance.runtimeType}');
  }

  void dispose() {
    _typeCheckers.clear();
  }
}
