import 'dart:convert';

import 'package:flutter/material.dart';

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

  void prettyPrintJson({required String json, required String keyword}) {
    const enc = JsonEncoder.withIndent('    ');
    final conv = enc.convert(json);

    debugPrint('[$keyword]: $conv');
  }
}
