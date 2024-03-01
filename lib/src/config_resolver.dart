import 'package:digia_ui/src/Utils/dui_font.dart';
import 'package:digia_ui/src/core/page/dui_page_state.dart';

class DigiaUIConfigResolver {
  final Map<String, dynamic> _themeConfig;
  final Map<String, dynamic> _pages;
  final Map<String, dynamic> _restConfig;
  final String _initialRoute;

  DigiaUIConfigResolver(dynamic data)
      : _themeConfig = data['theme'],
        _pages = data['pages'],
        _restConfig = data['rest'],
        _initialRoute = data['appSettings']['initialRoute'];

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
}
