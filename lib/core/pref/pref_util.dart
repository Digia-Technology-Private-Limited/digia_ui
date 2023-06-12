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

  // static bool getBool(String key, [bool? defValue]) {
  //   return _pref.getBool(key) ?? defValue!;
  // }

  // static Future<bool> setBool(String key, bool value) async {
  //   return _pref.setBool(key, value) ?? Future.value(false);
  // }

  // static int getInt(String key, [int? defValue]) {
  //   return _pref.getInt(key) ?? defValue!;
  // }

  // static Future<bool> setInt(String key, int value) async {
  //   var prefs = await _pref;
  //   return prefs?.setInt(key, value) ?? Future.value(false);
  // }

  // static List<String> getStringList(String key, [List<String>? defValue]) {
  //   return _pref.getStringList(key) ?? [];
  // }

  // static Future<bool> setStringList(String key, List<String> value) async {
  //   var prefs = await _pref;
  //   return prefs?.setStringList(key, value) ?? Future.value(false);
  // }

  static Future<bool> clearStorage() async {
    return _pref.clear();
  }
}
