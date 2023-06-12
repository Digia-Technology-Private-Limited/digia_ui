import 'dart:convert';

import 'package:digia_ui/Utils/dui_font.dart';
import 'package:digia_ui/core/page/page_init_data.dart';
import 'package:digia_ui/core/pref/pref_util.dart';
import 'package:flutter/services.dart';

class ConfigResolver {
  late Map<String, dynamic> _themeConfig;
  late Map<String, dynamic> _pages;

  static final ConfigResolver _instance = ConfigResolver._internal();

  factory ConfigResolver() {
    return _instance;
  }

  static initialize(String assetPath) async {
    final response = await rootBundle.loadString(assetPath);
    final data = await jsonDecode(response);
    _instance._themeConfig = data['theme'];
    _instance._pages = data['pages'];
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
          pageName: 'easy-eat',
          pageConfig: getPageConfig('easy-eat')!,
          inputArgs: null);
    }

    final firstPageConfig = _pages['onboardingPage'];
    if (firstPageConfig == null || firstPageConfig['pageName'] == null) {
      throw 'Config for First Page not found.';
    }

    final pageName = firstPageConfig['pageName'];
    if (pageName == null) {
      throw 'Page Name not present in First Page Config';
    }

    final pageConfig = getPageConfig(firstPageConfig['pageName']);
    if (pageConfig == null) {
      throw 'Page Config not found for $pageName';
    }

    return PageInitData(
        pageName: firstPageConfig['pageName'],
        pageConfig: pageConfig,
        inputArgs: firstPageConfig['inputArgs']);
  }
}
