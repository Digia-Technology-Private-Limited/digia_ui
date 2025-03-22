import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../digia_ui.dart';
import 'Utils/download_operations.dart';
import 'Utils/file_operations.dart';
import 'config/model.dart';
import 'core/appConfig/app_config.dart';
import 'core/functions/js_functions.dart';

class AppConfigResolver {
  final FlavorInfo _flavorInfo;
  final FileOperations fileOps = const FileOperationsImpl();
  final FileDownloader downloadOps = FileDownloaderImpl();

  AppConfigResolver(this._flavorInfo);


  Exception _buildInitException(String reason) {
    print(reason);
    return Exception('Digia init failed ======> $reason');
  }

  Future<void> _initFunctions({String? remotePath, String? localPath, int? version}) async {
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
    AppConfig config = AppConfig();
    try {
      var appConfig = DUIConfig(await config
          .getAppConfigFileFromNetwork('/config/getAppConfigRelease'));
      if (appConfig.functionsFilePath != null) {
        downloadOps.downloadFile(appConfig.functionsFilePath!,
            JSFunctions.getFunctionsFileName(appConfig.version));
      }
    } catch (e) {
      print(
          '_fetchAndCacheProductionAppConfigAndFunctions : AppConfig network fetch failed or no new version released');
    }
  }

  Future<DUIConfig> getConfig() async {
    AppConfig config = AppConfig();
    DUIConfig appConfig;
    DUIConfig? cachedAppConfig, burnedAppConfig;
    int? version;
    switch (_flavorInfo) {
      case Debug():
        try {
          appConfig = DUIConfig(
              await config.getAppConfigFromNetwork('/config/getAppConfig'));
        } catch (e) {
          throw _buildInitException('Invalid AppConfig or fetch failed');
        }
        await _initFunctions(remotePath: appConfig.functionsFilePath);
        return appConfig;
      case Staging():
        try {
          appConfig = DUIConfig(await config
              .getAppConfigFromNetwork('/config/getAppConfigStaging'));
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
            appConfig = DUIConfig(await config
                .getAppConfigFileFromNetwork('/config/getAppConfigRelease'));
          } catch (e) {
            throw _buildInitException('Invalid AppConfig or fetch failed');
          }
          await _initFunctions(
              remotePath: appConfig.functionsFilePath,
              version: appConfig.version);
          return appConfig;
        }
        try {
          var cachedAppConfigJson = await fileOps.readString('appConfig.json');
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
                Future<Object?>.delayed(Duration(seconds: timeout)),
                config
                    .getAppConfigFileFromNetwork('/config/getAppConfigRelease')
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
          appConfig = DUIConfig(await config
              .getAppConfigFromNetwork('/config/getAppConfigForVersion'));
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

  Future<DUIConfig> _initBurnedAppConfig(DUIConfig burnedAppConfig, String functionsPath) async {
    await _initFunctions(localPath: functionsPath);
    return burnedAppConfig;
  }
}
