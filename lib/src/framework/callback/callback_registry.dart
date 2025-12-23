import 'package:flutter/widgets.dart';

/// Type definition for a native Dart callback that can be executed by
/// the `Action.executeCallback` action.
///
/// The callback receives a map of arguments that were passed via `argUpdates`
/// in the executeCallback action configuration.
///
/// Returns an optional Future that can resolve to any value, which will be
/// available as the result of the callback execution.
typedef DUICallback = Future<Object?>? Function(Map<String, dynamic> args);

/// Registry for storing native Dart callbacks that can be executed by components.
///
/// This allows developers to pass callbacks when using `createComponent` that
/// can be triggered by `Action.executeCallback` actions defined in the dashboard.
///
/// Example usage:
/// ```dart
/// DUIFactory().createComponent(
///   'my_component',
///   {'title': 'Hello'},
///   callbacks: {
///     'onButtonClick': (args) async {
///       print('Button clicked with args: $args');
///       return {'success': true};
///     },
///   },
/// );
/// ```
class CallbackRegistry {
  final Map<String, DUICallback> _callbacks;

  /// Creates a new callback registry with the given callbacks.
  CallbackRegistry([Map<String, DUICallback>? callbacks])
      : _callbacks = {...?callbacks};

  /// Registers a callback with the given name.
  void register(String name, DUICallback callback) {
    _callbacks[name] = callback;
  }

  /// Registers multiple callbacks at once.
  void registerAll(Map<String, DUICallback> callbacks) {
    _callbacks.addAll(callbacks);
  }

  /// Gets a callback by name, returns null if not found.
  DUICallback? get(String name) => _callbacks[name];

  /// Checks if a callback with the given name exists.
  bool has(String name) => _callbacks.containsKey(name);

  /// Removes a callback by name.
  void remove(String name) => _callbacks.remove(name);

  /// Clears all callbacks.
  void clear() => _callbacks.clear();

  /// Returns all callback names.
  Iterable<String> get names => _callbacks.keys;

  /// Returns true if no callbacks are registered.
  bool get isEmpty => _callbacks.isEmpty;

  /// Returns true if at least one callback is registered.
  bool get isNotEmpty => _callbacks.isNotEmpty;
}

/// InheritedWidget that provides callback registry to the widget tree.
///
/// This allows the `ExecuteCallbackProcessor` to access native callbacks
/// when executing `Action.executeCallback` actions.
class CallbackProvider extends InheritedWidget {
  /// The callback registry containing native Dart callbacks.
  final CallbackRegistry registry;

  const CallbackProvider({
    super.key,
    required this.registry,
    required super.child,
  });

  /// Retrieves the CallbackRegistry from the widget tree.
  ///
  /// Returns null if no CallbackProvider is found in the ancestor tree.
  static CallbackRegistry? maybeOf(BuildContext context) {
    return context
        .getInheritedWidgetOfExactType<CallbackProvider>()
        ?.registry;
  }

  /// Retrieves the CallbackRegistry from the widget tree.
  ///
  /// Throws if no CallbackProvider is found in the ancestor tree.
  static CallbackRegistry of(BuildContext context) {
    final registry = maybeOf(context);
    assert(registry != null, 'No CallbackProvider found in widget tree');
    return registry!;
  }

  @override
  bool updateShouldNotify(CallbackProvider oldWidget) {
    // Always return false since we use getInheritedWidgetOfExactType
    // (not dependOnInheritedWidgetOfExactType) in maybeOf/of methods.
    // This prevents any unnecessary rebuild notifications.
    // Callbacks are accessed during action execution, not during widget build.
    return false;
  }
}
