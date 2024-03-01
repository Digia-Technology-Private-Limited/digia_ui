import 'dart:convert';

class JsonUtil {
  static dynamic tryDecode(String str) {
    try {
      return jsonDecode(str);
    } catch (e) {
      // ignore: avoid_print
      print('tryDecode failed for String: \n$str');
      return null;
    }
  }
}
