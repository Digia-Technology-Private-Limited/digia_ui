import 'package:digia_ui/src/Utils/json_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      return JsonUtil.tryDecode(value) ?? value;
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
