import 'dart:async';

import '../../preferences_store.dart';
import 'reactive_value.dart';
import 'reactive_value_factory.dart';
import 'state_descriptor_parser.dart';

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

  final Map<String, ReactiveValue<Object?>> _values = {};
  bool _isInitialized = false;

  DUIAppState._internal();

  /// Initialize the global state with SharedPreferences and state descriptors
  ///
  /// [descriptors] - List of state descriptors to initialize
  /// [prefs] - SharedPreferences instance
  Future<void> init(List<dynamic> values) async {
    if (_isInitialized) {
      dispose();
    }

    final descriptors =
        values.map((e) => StateDescriptorFactory().fromJson(e)).toList();

    for (final descriptor in descriptors) {
      if (_values.containsKey(descriptor.key)) {
        throw Exception('Duplicate state key: ${descriptor.key}');
      }

      // Create either PersistedReactiveValue or ReactiveValue based on shouldPersist
      final value = DefaultReactiveValueFactory().create(
        descriptor,
        PreferencesStore.instance.prefs,
      );

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

  Map<String, ReactiveValue<Object?>> get value => _values;

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
