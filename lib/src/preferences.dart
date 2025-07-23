import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'framework/utils/json_util.dart';

class DUIPreferences {
  static final DUIPreferences _instance = DUIPreferences._();

  static late SharedPreferences _pref;

  DUIPreferences._();

  static DUIPreferences get instance => _instance;

  static Future<void> initialize() async {
    _pref = await SharedPreferences.getInstance();
  }

  String? getString(String key, [String? defValue]) {
    return _pref.getString(key) ?? defValue;
  }

  int? getInt(String key, [int? defValue]) {
    return _pref.getInt(key) ?? defValue;
  }

  double? getDouble(String key, [double? defValue]) {
    return _pref.getDouble(key) ?? defValue;
  }

  bool? getBool(String key, [bool? defValue]) {
    return _pref.getBool(key) ?? defValue;
  }

  Object? get(String key) {
    var value = _pref.get(key);

    if (value is String) {
      return tryJsonDecode(value) ?? value;
    }

    return value;
  }

  Future<bool> setString(String key, String value) =>
      _pref.setString(key, value);
  Future<bool> setBool(String key, bool value) => _pref.setBool(key, value);
  Future<bool> setDouble(String key, double value) =>
      _pref.setDouble(key, value);
  Future<bool> setInt(String key, int value) => _pref.setInt(key, value);

  Future<bool> remove(String key) {
    return _pref.remove(key);
  }

  Future<bool> clear() async {
    return _pref.clear();
  }
}

class DUISettings {
  static final DUISettings _instance = DUISettings._();
  static const String _uuidKey = 'uuid';

  DUISettings._();

  static DUISettings get instance => _instance;

  String getUuid() {
    String? uuid = PreferencesStore.instance.read<String>(_uuidKey);
    if (uuid == null) {
      uuid = const Uuid().v4();
      PreferencesStore.instance.write(_uuidKey, uuid);
    }

    return uuid;
  }
}

class PreferencesStore {
  static final PreferencesStore _instance = PreferencesStore._();
  static const String _keyPrefix = 'digia_ui.';

  static late SharedPreferences _pref;

  PreferencesStore._();

  static PreferencesStore get instance => _instance;

  static Future<void> initialize() async {
    _pref = await SharedPreferences.getInstance();
  }

  String _addPrefix(String key) => '$_keyPrefix$key';

  T? read<T>(String key, [T? defaultValue]) {
    final prefixedKey = _addPrefix(key);
    final value = _pref.get(prefixedKey);

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
      return _pref.setString(prefixedKey, value);
    } else if (value is int) {
      return _pref.setInt(prefixedKey, value);
    } else if (value is double) {
      return _pref.setDouble(prefixedKey, value);
    } else if (value is bool) {
      return _pref.setBool(prefixedKey, value);
    } else {
      // For complex objects, encode as JSON string
      final jsonString = jsonEncode(value);
      return _pref.setString(prefixedKey, jsonString);
    }
  }

  Future<bool> delete(String key) {
    return _pref.remove(_addPrefix(key));
  }

  Future<bool> clear() async {
    final keys = _pref.getKeys().where((key) => key.startsWith(_keyPrefix));
    for (final key in keys) {
      await _pref.remove(key);
    }
    return true;
  }

  bool contains(String key) {
    return _pref.containsKey(_addPrefix(key));
  }

  Set<String> getKeys() {
    return _pref
        .getKeys()
        .where((key) => key.startsWith(_keyPrefix))
        .map((key) => key.substring(_keyPrefix.length))
        .toSet();
  }
}
