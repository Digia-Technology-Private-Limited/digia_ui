import 'package:shared_preferences/shared_preferences.dart';

import 'reactive_value.dart';

/// A reactive value that can optionally persist its value to SharedPreferences
class PersistedReactiveValue<T> extends ReactiveValue<T> {
  final SharedPreferences _prefs;
  final String _key;
  final bool _shouldPersist;
  final T Function(String) _fromString;
  final String Function(T) _toString;

  /// Create a new PersistedReactiveValue
  ///
  /// [prefs] - SharedPreferences instance
  /// [key] - Unique key for storage
  /// [initialValue] - Initial value if no persisted value exists
  /// [shouldPersist] - Whether to persist changes to SharedPreferences
  /// [fromString] - Function to convert from stored string to value
  /// [toString] - Function to convert value to string for storage
  PersistedReactiveValue({
    required SharedPreferences prefs,
    required String key,
    required T initialValue,
    bool shouldPersist = true,
    required T Function(String) fromString,
    required String Function(T) toString,
  })  : _prefs = prefs,
        _key = key,
        _shouldPersist = shouldPersist,
        _fromString = fromString,
        _toString = toString,
        super(_loadValue(prefs, key, initialValue, fromString));

  static T _loadValue<T>(
    SharedPreferences prefs,
    String key,
    T initialValue,
    T Function(String) fromString,
  ) {
    final stored = prefs.getString(key);
    return stored != null ? fromString(stored) : initialValue;
  }

  @override
  bool update(T newValue) {
    final updated = super.update(newValue);
    if (updated && _shouldPersist) {
      _prefs.setString(_key, _toString(newValue));
    }
    return updated;
  }
}
