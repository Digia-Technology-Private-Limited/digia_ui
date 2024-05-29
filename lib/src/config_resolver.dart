import 'Utils/dui_font.dart';
import 'core/page/props/dui_page_props.dart';
import 'network/api_request/api_request.dart';

class DUIConfig {
  final Map<String, dynamic> _themeConfig;
  final Map<String, dynamic> _pages;
  final Map<String, dynamic> _restConfig;
  final String _initialRoute;
  final String functionsFilePath;
  final Map<String, dynamic>? appState;

  DUIConfig(dynamic data)
      : _themeConfig = data['theme'],
        _pages = data['pages'],
        _restConfig = data['rest'],
        _initialRoute = data['appSettings']['initialRoute'],
        appState = data['appState'],
        functionsFilePath = data['functionsFilePath'];

  // TODO: @tushar - Add support for light / dark theme
  Map<String, dynamic> get _colors => _themeConfig['colors']['light'];
  Map<String, dynamic> get _fonts => _themeConfig['fonts'];

  String? getColorValue(String colorToken) {
    return _colors[colorToken];
  }

  DUIFont getFont(String fontToken) {
    var fontsJson = (_fonts[fontToken]);
    return DUIFont.fromJson(fontsJson);
  }

  // Map<String, dynamic>? getPageConfig(String uid) {
  //   return _pages[uid];
  // }

  DUIPageProps getPageData(String pageUid) {
    final pageConfig = _pages[pageUid];
    if (pageConfig == null) {
      throw 'Config for Page: $pageUid not found';
    }
    return DUIPageProps.fromJson(pageConfig);
  }

  DUIPageProps getfirstPageData() {
    final firstPageConfig = _pages[_initialRoute];
    if (firstPageConfig == null || firstPageConfig['uid'] == null) {
      throw 'Config for First Page not found.';
    }

    return DUIPageProps.fromJson(firstPageConfig);
  }

  Map<String, dynamic>? getDefaultHeaders() {
    return _restConfig['defaultHeaders'];
  }

  APIModel getApiDataSource(String id) {
    return APIModel.fromJson(_restConfig['resources'][id]);
  }
}
