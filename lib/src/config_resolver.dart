import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../digia_ui.dart';
import 'Utils/dui_font.dart';
import 'Utils/file_operations.dart';
import 'core/functions/download.dart';
import 'core/functions/js_functions.dart';
import 'core/functions/mobile_js_functions.dart';
import 'core/page/props/dui_page_props.dart';
import 'network/api_request/api_request.dart';
import 'network/core/types.dart';

class AppConfigResolver {
  final EnvironmentInfo _environment;
  AppConfigResolver(this._environment);

  Future<Map<String, dynamic>?> _getAppConfigFromNetwork(path) async {
    var resp = await DigiaUIClient.instance.networkClient.requestInternal(
      HttpMethod.post,
      path,
      (json) => json as dynamic,
    );
    final data = resp.data['response'] as Map<String, dynamic>?;
    return data;
  }

  Future<Map<String, dynamic>?> _getAppConfigFromNetworkAndWriteToFile(String path) async {
    try {
      final data = await _getAppConfigFromNetwork(path);
      if (data != null && data.isNotEmpty && data['versionUpdated'] == true) {
        await writeStringToFile(json.encode(data), 'appConfig.json');
      }
      return data;
    } catch (e) {
      return null;
    }
  }

  Exception _buildInitException(String reason) {
    print(reason);
    return Exception('Digia init failed ======> $reason');
  }

  Future<void> _initFunctions(
      {String? remotePath, String? localPath, int? version}) async {
    print(version);
    if (remotePath != null) {
      var jsFunctions = JSFunctions();
      var res =
          await jsFunctions.initFunctions(PreferRemote(remotePath, version));
      if (!res) {
        throw _buildInitException('Functions not initialized');
      }
      DigiaUIClient.instance.jsFunctions = jsFunctions;
    }
    if (localPath != null) {
      var jsFunctions = JSFunctions();
      var res = await jsFunctions.initFunctions(PreferLocal(localPath));
      if (!res) {
        throw _buildInitException('Functions not initialized');
      }
      DigiaUIClient.instance.jsFunctions = jsFunctions;
    }
  }

  void _fetchAndCacheProductionAppConfigAndFunctions() async {
    var config = DUIConfig(
        await _getAppConfigFromNetworkAndWriteToFile('/config/getAppConfigProduction'));
    if (config.functionsFilePath != null) {
      downloadFunctionsFile(config.functionsFilePath!,
          MobileJsFunctions.getFunctionsFileName(config.version));
    }
  }

  Future<DUIConfig> getConfig() async {
    DUIConfig appConfig;
    switch (_environment) {
      case Staging():
        try {
          appConfig =
              DUIConfig(await _getAppConfigFromNetwork('/config/getAppConfig'));
          appConfig.getfirstPageData();
        } catch (e) {
          throw _buildInitException('Invalid AppConfig or fetch failed');
        }
        await _initFunctions(remotePath: appConfig.functionsFilePath);
        return appConfig;
      case Production(
          initPriority: InitPriority initPriority,
          appConfigPath: String appConfigPath,
          functionsPath: String functionsPath
        ):
        // If Web priority doesnt matter. Always fetch from network
        if (kIsWeb) {
          try {
            appConfig = DUIConfig(await _getAppConfigFromNetwork(
                '/config/getAppConfigProduction'));
            appConfig.getfirstPageData();
          } catch (e) {
            throw _buildInitException('Invalid AppConfig or fetch failed');
          }
          await _initFunctions(
              remotePath: appConfig.functionsFilePath,
              version: appConfig.version);
          return appConfig;
        }
        String? cachedAppConfigJson = await readFileString('appConfig.json');
        String burnedAppConfigJson;
        try {
          burnedAppConfigJson = await rootBundle.loadString(appConfigPath);
        } catch (e) {
          throw _buildInitException('Burned appConfig not found');
        }

        switch (initPriority) {
          case PrioritizeNetwork(timeout: int timeout):
            //try to fetch appConfig and functions from network
            try {
              var result = await Future.any([
                Future.delayed(Duration(seconds: timeout)),
                _getAppConfigFromNetworkAndWriteToFile('/config/getAppConfigProduction')
              ]);
              if (result == null) {
                throw _buildInitException('Invalid AppConfig or fetch failed');
              } else {
                appConfig = DUIConfig(result);
                await _initFunctions(
                    remotePath: appConfig.functionsFilePath,
                    version: appConfig.version);
                return appConfig;
              }
            } catch (e) {
              //If network fails build appconfig from cache
              try {
                print('AppConfig network fetch failed. Fallback to cached');
                return await _getCachedAppConfig(cachedAppConfigJson!);
              } catch (e) {
                //If cache fails build appconfig from burned assets
                try {
                  print('AppConfig cache failed. Fallback to burned');
                  return await _getBurnedAppConfig(burnedAppConfigJson, functionsPath);
                } catch (e) {
                  print('Appconfig all fallback failed');
                  throw _buildInitException(
                      'Invalid AppConfig or fetch failed');
                }
              }
            }
          case PrioritizeCache():
            _fetchAndCacheProductionAppConfigAndFunctions();
            try {
              return await _getCachedAppConfig(cachedAppConfigJson!);
            } catch (e) {
              try {
                print('AppConfig cache failed. Fallback to burned');
                return await _getBurnedAppConfig(burnedAppConfigJson, functionsPath);
              } catch (e) {
                print('Appconfig all fallback failed');
                throw _buildInitException('Invalid AppConfig or fetch failed');
              }
            }
          case PrioritizeLocal():
            try {
              return await _getBurnedAppConfig(burnedAppConfigJson, functionsPath);
            } catch (e) {
              throw _buildInitException('Invalid AppConfig or fetch failed');
            }
        }
      case Versioned():
        try {
          appConfig = DUIConfig(
              await _getAppConfigFromNetwork('/config/getAppConfigForVersion'));
        } catch (e) {
          throw _buildInitException('Invalid AppConfig or fetch failed');
        }
        await _initFunctions(
            remotePath: appConfig.functionsFilePath,
            version: appConfig.version);
        return appConfig;
    }
  }

  Future<DUIConfig> _getCachedAppConfig(String cachedJson) async {
    var appConfig = DUIConfig(
                  (json.decode(cachedJson) as Map<String, dynamic>));
    await _initFunctions(
        remotePath: appConfig.functionsFilePath,
        version: appConfig.version);
    return appConfig;
  }

  Future<DUIConfig> _getBurnedAppConfig(String burnedJson, String functionsPath) async {
    var appConfig = DUIConfig((json.decode(burnedJson)
                  as Map<String, dynamic>)['data']['response']);
    await _initFunctions(localPath: functionsPath);
    return appConfig;
  }
}

class DUIConfig {
  final Map<String, dynamic> _themeConfig;
  final Map<String, dynamic> _pages;
  final Map<String, dynamic> _restConfig;
  final String _initialRoute;
  final String? functionsFilePath;
  final Map<String, dynamic>? appState;
  final bool? versionUpdated;
  final int? version;

  DUIConfig(dynamic data)
      : _themeConfig = data['theme'],
        _pages = data['pages'],
        _restConfig = data['rest'],
        _initialRoute = data['appSettings']['initialRoute'],
        appState = data['appState'],
        version = data['version'],
        versionUpdated = data['versionUpdated'],
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
