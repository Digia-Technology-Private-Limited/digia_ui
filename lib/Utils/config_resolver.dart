import 'dart:convert';

import 'package:digia_ui/Utils/dui_font.dart';
import 'package:digia_ui/core/page/dui_page_state.dart';
import 'package:flutter/services.dart';

class ConfigResolver {
  late Map<String, dynamic> _themeConfig;
  late Map<String, dynamic> _pages;
  late Map<String, dynamic> _restConfig;
  late String _initialRoute;

  static final ConfigResolver _instance = ConfigResolver._internal();

  factory ConfigResolver() {
    return _instance;
  }

  static initialize(String assetPath) async {
    final response = await rootBundle.loadString(assetPath);
    final data = await jsonDecode(response);
    _instance._themeConfig = data['theme'];
    _instance._pages = data['pages'];
    _instance._restConfig = data['rest'];
    _instance._initialRoute = data['appSettings']['initialRoute'];
  }


  static initializeByJson(dynamic data) async {
    // final data = await jsonDecode(response);
    _instance._themeConfig = data['theme'];
    _instance._pages = data['pages'];
    _instance._restConfig = data['rest'];
    _instance._initialRoute = data['appSettings']['initialRoute'];
  }


  ConfigResolver._internal();

  // TOOD: @tushar - Add support for light / dark theme
  Map<String, dynamic> get _colors => _themeConfig['colors'];
  Map<String, dynamic> get _fonts => _themeConfig['fonts'];

  String? getColorValue(String colorToken) {
    return _colors[colorToken];
  }

  DUIFont getFont(String fontToken) {
    var fontsJson = (_fonts[fontToken]);
    return DUIFont.fromJson(fontsJson);
  }

  Map<String, dynamic>? getPageConfig(String uid) {
    return _pages[uid];
  }

  DUIPageInitData getfirstPageData() {
    final firstPageConfig = _pages[_initialRoute];
    if (firstPageConfig == null || firstPageConfig['uid'] == null) {
      throw 'Config for First Page not found.';
    }

    return DUIPageInitData(
        identifier: firstPageConfig['uid'], config: firstPageConfig);
  }

  Map<String, dynamic>? getDefaultHeaders() {
    return _restConfig['defaultHeaders'];
  }

  String? get baseUrl => _restConfig['baseUrl'];
}
