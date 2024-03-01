import 'dart:convert';

import 'package:digia_ui/src/Utils/json_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtil {
  static late final SharedPreferences _pref;

  static Future<SharedPreferences> init() async =>
      _pref = await SharedPreferences.getInstance();

  // call this method from iniState() function of mainApp().
  static String? getString(String key, [String? defValue]) {
    return _pref.getString(key) ?? defValue;
  }

  static Future<bool> setString(String key, String value) async {
    return _pref.setString(key, value);
  }

  static Future<bool> set(String key, dynamic value) {
    if (value is String) {
      return _pref.setString(key, value);
    }

    if (value != null) {
      return _pref.setString(key, jsonEncode(value));
    }

    return Future.value(false);
  }

  static dynamic get(String key) {
    final value = _pref.getString(key);

    if (value == null) return null;

    final decodedValue = JsonUtil.tryDecode(value);

    return decodedValue ?? value;
  }

  static Future<bool> clearStorage() async {
    return _pref.clear();
  }
}
