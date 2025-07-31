import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'framework/utils/json_util.dart';

class PreferencesStore {
  static final PreferencesStore _instance = PreferencesStore._();
  static const String _keyPrefix = 'digia_ui.';

  late SharedPreferences prefs;

  PreferencesStore._();

  static PreferencesStore get instance => _instance;

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  String _addPrefix(String key) => '$_keyPrefix$key';

  T? read<T>(String key, [T? defaultValue]) {
    final prefixedKey = _addPrefix(key);
    final value = prefs.get(prefixedKey);

    if (value == null) return defaultValue;

    if (T == String) return value as T?;
    if (T == int) return value as T?;
    if (T == double) return value as T?;
    if (T == bool) return value as T?;

    // For complex objects, try to decode JSON if it's a string
    if (value is String) {
      final decoded = tryJsonDecode(value);
      return decoded as T? ?? defaultValue;
    }

    return value as T? ?? defaultValue;
  }

  Future<bool> write<T>(String key, T value) async {
    final prefixedKey = _addPrefix(key);

    if (value is String) {
      return prefs.setString(prefixedKey, value);
    } else if (value is int) {
      return prefs.setInt(prefixedKey, value);
    } else if (value is double) {
      return prefs.setDouble(prefixedKey, value);
    } else if (value is bool) {
      return prefs.setBool(prefixedKey, value);
    } else {
      // For complex objects, encode as JSON string
      final jsonString = jsonEncode(value);
      return prefs.setString(prefixedKey, jsonString);
    }
  }

  Future<bool> delete(String key) {
    return prefs.remove(_addPrefix(key));
  }

  Future<bool> clear() async {
    final keys = prefs.getKeys().where((key) => key.startsWith(_keyPrefix));
    for (final key in keys) {
      await prefs.remove(key);
    }
    return true;
  }

  bool contains(String key) {
    return prefs.containsKey(_addPrefix(key));
  }

  Set<String> getKeys() {
    return prefs
        .getKeys()
        .where((key) => key.startsWith(_keyPrefix))
        .map((key) => key.substring(_keyPrefix.length))
        .toSet();
  }
}
