import 'dart:convert';

import 'package:digia_ui/Utils/dui_font.dart';
import 'package:flutter/services.dart';

class ConfigResolver {
  late Map<String, dynamic> themeConfig;

  static final ConfigResolver _instance = ConfigResolver._internal();

  factory ConfigResolver() {
    return _instance;
  }

  static initialize(String assetPath) async {
    final response = await rootBundle.loadString(assetPath);
    final data = await jsonDecode(response);
    _instance.themeConfig = data['theme'];
  }

  ConfigResolver._internal();

  Map<String, dynamic> get _colors => themeConfig['colors'];
  Map<String, dynamic> get _fonts => themeConfig['fonts'];

  String? getColorValue(String colorToken) {
    return _colors[colorToken];
  }

  DUIFont getFont(String fontToken) {
    var fontsJson = jsonDecode(_fonts[fontToken]);
    return DUIFont.fromJson(fontsJson);
  }
}
