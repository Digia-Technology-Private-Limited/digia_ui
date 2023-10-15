import 'dart:convert';

import 'package:digia_ui/Utils/dui_font.dart';
import 'package:digia_ui/core/page/page_init_data.dart';
import 'package:digia_ui/core/pref/pref_util.dart';
import 'package:flutter/services.dart';

class ConfigResolver {
  late Map<String, dynamic> _themeConfig;
  late Map<String, dynamic> _pages;
  late Map<String, dynamic> _restConfig;

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
  }

  ConfigResolver._internal();

  Map<String, dynamic> get _colors => _themeConfig['colors'];
  Map<String, dynamic> get _fonts => _themeConfig['fonts'];
  Map<String, dynamic> get _spacing => _themeConfig['spacing'];

  String? getColorValue(String colorToken) {
    return _colors[colorToken];
  }

  DUIFont getFont(String fontToken) {
    var fontsJson = (_fonts[fontToken]);
    return DUIFont.fromJson(fontsJson);
  }

  double? getSpacing(String spacingToken) {
    return _spacing[spacingToken];
  }

  Map<String, dynamic>? getPageConfig(String pageName) {
    return _pages[pageName];
  }

  PageInitData getfirstPageData() {
    // TODO: Remove this custom logic later.
    final authToken = PrefUtil.getString('authToken');

    if (authToken != null) {
      return PageInitData(
          pageName: 'easy-eat-login',
          pageConfig: getPageConfig('easy-eat-login')!,
          inputArgs: null);
    }

    final firstPageConfig = _pages['focusedPageId'];
    if (firstPageConfig == null || firstPageConfig['slug'] == null) {
      throw 'Config for First Page not found.';
    }

    final pageName = firstPageConfig['slug'];
    if (pageName == null) {
      throw 'Page Name not present in First Page Config';
    }

    final pageConfig = getPageConfig(firstPageConfig['slug']);
    if (pageConfig == null) {
      throw 'Page Config not found for $pageName';
    }

    return PageInitData(
        pageName: firstPageConfig['slug'],
        pageConfig: pageConfig,
        inputArgs: firstPageConfig['inputArgs']);
  }

  Map<String, dynamic>? getDefaultHeaders() {
    return _restConfig['defaultHeaders'];
  }
}
