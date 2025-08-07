import 'dart:convert';

import '../../utils/logger.dart';
import 'types.dart';

typedef JsonReviver = Object? Function(Object? key, Object? value);

/// Attempts to decode a JSON string, returning null if decoding fails.
///
/// This function provides a safe way to decode JSON without throwing exceptions.
///
/// [source] The JSON string to decode.
/// [reviver] An optional function that can be used to transform the decoded values.
///
/// Returns the decoded JSON object, or null if decoding fails.
Object? tryJsonDecode(String source, {JsonReviver? reviver}) {
  try {
    return jsonDecode(source, reviver: reviver);
  } catch (e) {
    // Consider using a logging framework instead of print for production code
    Logger.error('JSON decode error: $e', tag: 'JsonUtil', error: e);
    return null;
  }
}

/// Attempts to retrieve a value from a JSON object using multiple possible keys.
///
/// [json] The JSON object to search in.
/// [keys] An ordered list of keys to try.
/// [parse] Optional function to cast or transform the value if found.
///
/// Returns the value associated with the first matching key, or null if no key is found.
T? tryKeys<T>(
  JsonLike json,
  List<String> keys, {
  T? Function(Object?)? parse,
}) {
  for (final key in keys) {
    if (json.containsKey(key)) {
      final value = json[key];
      return parse != null ? parse(value) : value as T?;
    }
  }
  return null;
}

extension KeyPath on JsonLike {
  /// Retrieves the value for a given key path in a nested map.
  ///
  /// The [keyPath] parameter is a dot-separated string representing the path to the desired value.
  /// For example, 'a.b.c' will retrieve the value at map['a']['b']['c'].
  Object? valueFor(String keyPath) {
    // Split the keyPath into individual keys
    final keysSplit = keyPath.split('.');

    // Remove and get the first key from the list
    final thisKey = keysSplit.removeAt(0);

    // Get the value associated with the first key
    final thisValue = this[thisKey];

    // If there are no more keys, return the current value
    if (keysSplit.isEmpty) {
      return thisValue;
    }
    // If the current value is a Map, recursively call valueFor on the remaining key path
    else if (thisValue is JsonLike) {
      return thisValue.valueFor(keysSplit.join('.'));
    }

    // If the current value is not a Map and there are still keys left, return null
    return null;
  }

  /// Sets the value for a given key path in a nested map.
  ///
  /// The [keyPath] parameter is a dot-separated string representing the path to the desired value.
  /// For example, 'a.b.c' will set the value at map['a']['b']['c'].
  /// If intermediate maps do not exist, they will be created.
  void setValueFor(String keyPath, Object? value) {
    // Split the keyPath into individual keys
    final keysSplit = keyPath.split('.');

    // Remove and get the first key from the list
    final thisKey = keysSplit.removeAt(0);

    // If there are no more keys, set the value at the current key
    if (keysSplit.isEmpty) {
      this[thisKey] = value;
      return;
    }

    // If the current value is not a Map, create a new Map
    if (this[thisKey] is! JsonLike) {
      this[thisKey] = <String, Object?>{};
    }

    // Recursively call setValueFor on the remaining key path
    (this[thisKey] as JsonLike).setValueFor(keysSplit.join('.'), value);
  }
}
