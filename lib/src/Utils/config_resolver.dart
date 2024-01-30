import 'dart:convert';
import 'package:digia_ui/src/Utils/dui_font.dart';
import 'package:digia_ui/src/core/page/dui_page_state.dart';
import 'package:digia_ui/src/network/core/types.dart';
import 'package:digia_ui/src/network/network_manager.dart';
import 'package:digia_ui/src/project_constants.dart';
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

  static _initializeVars(Map<String, dynamic> data) {
    _instance._themeConfig = data['theme'];
    _instance._pages = data['pages'];
    _instance._restConfig = data['rest'];
    _instance._initialRoute = data['appSettings']['initialRoute'];
  }

  static Future<bool> initializeFromCloud(String projectId) async {
    const baseUrl = ProjectConstants.baseUrl;
    try {
      final config = await NetworkManager().request(HttpMethod.post,
          '$baseUrl/config/getAppConfig', (json) => json as dynamic,
          data: jsonEncode({'projectId': projectId}));

      final resp = config.data['response'] as Map<String, dynamic>?;
      if (resp == null || resp.isEmpty) {
        print('Empty Config from Server');
        return false;
      }

      _initializeVars(resp);
    } catch (err) {
      print(err);
      return false;
    }

    return true;
  }

  ConfigResolver._internal();

  // TOOD: @tushar - Add support for light / dark theme
  Map<String, dynamic> get _colors => _themeConfig['colors']['light'];
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

  // String? get baseUrl => _restConfig['baseUrl'];
  String? get baseUrl => ProjectConstants.baseUrl;
}
