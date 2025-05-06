import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'reactive_value.dart';
import 'reactive_value_factory.dart';

/// Describes how a state value should behave
class StateDescriptor<T> {
  final String key;
  final T initialValue;
  final bool shouldPersist;
  final T Function(String) deserialize;
  final String Function(T) serialize;
  final String? description;
  final String streamName;

  const StateDescriptor({
    required this.key,
    required this.initialValue,
    this.shouldPersist = true,
    required this.deserialize,
    required this.serialize,
    this.description,
    required this.streamName,
  });
}

/// Global state manager that holds multiple reactive values
class DUIAppState {
  static final DUIAppState _instance = DUIAppState._internal();
  factory DUIAppState() => _instance;

  final Map<String, ReactiveValue<dynamic>> _values = {};
  SharedPreferences? _prefs;
  bool _isInitialized = false;

  DUIAppState._internal();

  // Get current values
  Map<String, dynamic> get currentValues => Map.fromEntries(
      _values.entries.map((e) => MapEntry(e.key, e.value.value)));

  // Get controllers
  Map<String, StreamController> get controllers =>
      Map.fromEntries(_values.entries
          .map((e) => MapEntry(e.value.streamName, e.value.controller)));

  /// Initialize the global state with SharedPreferences and state descriptors
  ///
  /// [descriptors] - List of state descriptors to initialize
  /// [prefs] - SharedPreferences instance
  Future<void> init(
      List<StateDescriptor> descriptors, SharedPreferences prefs) async {
    if (_isInitialized) {
      dispose();
    }

    _prefs = prefs;

    for (final descriptor in descriptors) {
      if (_values.containsKey(descriptor.key)) {
        throw Exception('Duplicate state key: ${descriptor.key}');
      }

      // Create either PersistedReactiveValue or ReactiveValue based on shouldPersist
      final value = DefaultReactiveValueFactory().create(descriptor, prefs);

      _values[descriptor.key] = value;
    }

    _isInitialized = true;
  }

  /// Get a reactive value by key
  ReactiveValue<T> get<T>(String key) {
    if (!_isInitialized) {
      throw Exception('GlobalState must be initialized before getting values');
    }

    if (!_values.containsKey(key)) {
      throw Exception('State key "$key" not found');
    }

    final value = _values[key];
    if (value is! ReactiveValue<T>) {
      throw Exception('Type mismatch for key "$key"');
    }

    return value;
  }

  /// Get the current value by key
  T getValue<T>(String key) => get<T>(key).value;

  Map<String, ReactiveValue<dynamic>> get value => _values;

  /// Update a value by key
  bool update<T>(String key, T newValue) => get<T>(key).update(newValue);

  /// Listen to changes of a value
  StreamSubscription<T> listen<T>(String key, void Function(T) onData) {
    return get<T>(key).controller.stream.listen(onData);
  }

  /// Dispose all registered values
  void dispose() {
    for (final value in _values.values) {
      value.dispose();
    }
    _values.clear();
    _isInitialized = false;
  }
}
