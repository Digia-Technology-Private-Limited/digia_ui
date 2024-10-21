import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../digia_ui.dart';
import 'Utils/dui_font.dart';
import 'Utils/file_operations.dart';
import 'core/functions/download.dart';
import 'core/functions/js_functions.dart';
import 'core/page/props/dui_page_props.dart';
import 'framework/utils/functional_util.dart';
import 'models/variable_def.dart';
import 'network/api_request/api_request.dart';
import 'network/core/types.dart';

class AppConfigResolver {
  final FlavorInfo _flavorInfo;

  AppConfigResolver(this._flavorInfo);

  Future<Map<String, dynamic>?> _getAppConfigFromNetwork(path) async {
    var resp = await DigiaUIClient.instance.networkClient.requestInternal(
      HttpMethod.post,
      path as String,
      (json) => json as dynamic,
    );
    final data = resp.data['response'] as Map<String, dynamic>?;
    return data;
  }

  Future<Map<String, dynamic>?> _getAppConfigFromNetworkAndWriteToFile(
      String path) async {
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
    try {
      var config = DUIConfig(await _getAppConfigFromNetworkAndWriteToFile(
          '/config/getAppConfigProduction'));
      if (config.functionsFilePath != null) {
        downloadFunctionsFile(config.functionsFilePath!,
            JSFunctions.getFunctionsFileName(config.version));
      }
    } catch (e) {
      print(
          '_fetchAndCacheProductionAppConfigAndFunctions : AppConfig network fetch failed or no new version released');
    }
  }

  Future<DUIConfig> getConfig() async {
    DUIConfig appConfig;
    DUIConfig? cachedAppConfig, burnedAppConfig;
    int? version;
    switch (_flavorInfo) {
      case Debug():
        try {
          appConfig =
              DUIConfig(await _getAppConfigFromNetwork('/config/getAppConfig'));
        } catch (e) {
          throw _buildInitException('Invalid AppConfig or fetch failed');
        }
        await _initFunctions(remotePath: appConfig.functionsFilePath);
        return appConfig;
      case Staging():
        try {
          appConfig = DUIConfig(
              await _getAppConfigFromNetwork('/config/getAppConfigStaging'));
        } catch (e) {
          throw _buildInitException('Invalid AppConfig or fetch failed');
        }
        await _initFunctions(
            remotePath: appConfig.functionsFilePath,
            version: appConfig.version);
        return appConfig;
      case Release(
          initPriority: InitPriority initPriority,
          appConfigPath: String appConfigPath,
          functionsPath: String functionsPath
        ):
        // If Web priority doesnt matter. Always fetch from network
        if (kIsWeb) {
          try {
            appConfig = DUIConfig(await _getAppConfigFromNetwork(
                '/config/getAppConfigProduction'));
          } catch (e) {
            throw _buildInitException('Invalid AppConfig or fetch failed');
          }
          await _initFunctions(
              remotePath: appConfig.functionsFilePath,
              version: appConfig.version);
          return appConfig;
        }
        try {
          var cachedAppConfigJson = await readFileString('appConfig.json');
          cachedAppConfig = DUIConfig(
              (json.decode(cachedAppConfigJson!) as Map<String, dynamic>));
          version = cachedAppConfig.version;
        } catch (e) {
          //do nothing
        }

        try {
          var burnedAppConfigJson = await rootBundle.loadString(appConfigPath);
          burnedAppConfig = DUIConfig((json.decode(burnedAppConfigJson)
              as Map<String, dynamic>)['data']['response']);
          version ??= burnedAppConfig.version;
        } catch (e) {
          throw _buildInitException('Burned appConfig not found');
        }

        if (version != null) {
          DigiaUIClient.instance.networkClient.addVersionHeader(version);
        }

        switch (initPriority) {
          case PrioritizeNetwork(timeout: int timeout):
            //try to fetch appConfig and functions from network
            try {
              var result = await Future.any([
                Future.delayed(Duration(seconds: timeout)),
                _getAppConfigFromNetworkAndWriteToFile(
                    '/config/getAppConfigProduction')
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
                print(
                    'AppConfig network fetch failed or no new version released. Fallback to cached');
                return await _initCachedAppConfig(cachedAppConfig!);
              } catch (e) {
                //If cache fails build appconfig from burned assets
                try {
                  print('AppConfig cache failed. Fallback to burned');
                  return await _initBurnedAppConfig(
                      burnedAppConfig, functionsPath);
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
              return await _initCachedAppConfig(cachedAppConfig!);
            } catch (e) {
              try {
                print('AppConfig cache failed. Fallback to burned');
                return await _initBurnedAppConfig(
                    burnedAppConfig, functionsPath);
              } catch (e) {
                print('Appconfig all fallback failed');
                throw _buildInitException('Invalid AppConfig or fetch failed');
              }
            }
          case PrioritizeLocal():
            try {
              return await _initBurnedAppConfig(burnedAppConfig, functionsPath);
            } catch (e) {
              throw _buildInitException('Invalid AppConfig or fetch failed');
            }
        }
      case Versioned(version: int version):
        try {
          DigiaUIClient.instance.networkClient.addVersionHeader(version);
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

  Future<DUIConfig> _initCachedAppConfig(DUIConfig cachedAppConfig) async {
    await _initFunctions(
        remotePath: cachedAppConfig.functionsFilePath,
        version: cachedAppConfig.version);
    return cachedAppConfig;
  }

  Future<DUIConfig> _initBurnedAppConfig(
      DUIConfig burnedAppConfig, String functionsPath) async {
    await _initFunctions(localPath: functionsPath);
    return burnedAppConfig;
  }
}

class DUIConfig {
  final Map<String, dynamic> _themeConfig;
  final Map<String, Object?> pages;
  final Map<String, Object?>? components;
  final Map<String, dynamic> restConfig;
  final String initialRoute;
  final String? functionsFilePath;
  final Map<String, dynamic>? appState;
  final bool? versionUpdated;
  final int? version;
  final Map<String, dynamic>? _environment;

  DUIConfig(dynamic data)
      : _themeConfig = as<Map<String, dynamic>>(data['theme']),
        pages = as<Map<String, Object?>>(data['pages']),
        components = as$<Map<String, Object?>>(data['components']),
        restConfig = as<Map<String, dynamic>>(data['rest']),
        initialRoute = as<String>(data['appSettings']['initialRoute']),
        appState = as$<Map<String, dynamic>>(data['appState']),
        version = as$<int>(data['version']),
        versionUpdated = as$<bool>(data['versionUpdated']),
        functionsFilePath = as$<String>(data['functionsFilePath']),
        _environment = as$<Map<String, dynamic>>(data['environment']);

  // TODO: @tushar - Add support for light / dark theme
  Map<String, dynamic> get _colors =>
      as<Map<String, dynamic>>(_themeConfig['colors']['light']);
  Map<String, dynamic> get _fonts =>
      as<Map<String, dynamic>>(_themeConfig['fonts']);

  Map<String, Object?> get colorTokens =>
      as<Map<String, Object?>>(_themeConfig['colors']['light']);
  Map<String, Object?> get fontTokens =>
      as<Map<String, Object?>>(_themeConfig['fonts']);

  String? getColorValue(String colorToken) {
    return as$<String>(_colors[colorToken]);
  }

  DUIFont getFont(String fontToken) {
    var fontsJson = (_fonts[fontToken]);
    return DUIFont.fromJson(as<Map<String, dynamic>>(fontsJson));
  }

  // Map<String, dynamic>? getPageConfig(String uid) {
  //   return _pages[uid];
  // }

  DUIPageProps getPageData(String pageUid) {
    final pageConfig = pages[pageUid];
    if (pageConfig == null) {
      throw 'Config for Page: $pageUid not found';
    }
    return DUIPageProps.fromJson(pageConfig as Map<String, dynamic>);
  }

  DUIPageProps getfirstPageData() {
    final firstPageConfig = pages[initialRoute] as Map<String, dynamic>?;
    if (firstPageConfig == null || firstPageConfig['uid'] == null) {
      throw 'Config for First Page not found.';
    }

    return DUIPageProps.fromJson(firstPageConfig);
  }

  Map<String, dynamic>? getDefaultHeaders() {
    return as$<Map<String, dynamic>>(restConfig['defaultHeaders']);
  }

  Map<String, VariableDef> getEnvironmentVariables() {
    return const VariablesJsonConverter()
        .fromJson(as$<Map<String, dynamic>>(_environment?['variables']));
  }

  APIModel getApiDataSource(String id) {
    return APIModel.fromJson(
        as<Map<String, dynamic>>(restConfig['resources'][id]));
  }
}
