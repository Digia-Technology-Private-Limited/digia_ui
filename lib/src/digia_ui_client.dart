import 'dart:convert';
import 'dart:io';

import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../digia_ui.dart';
import 'Utils/file_operations.dart';
import 'core/functions/js_functions.dart';
import 'core/pref/dui_preferences.dart';
import 'digia_ui_service.dart';
import 'models/dui_app_state.dart';
import 'network/api_response/base_response.dart';
import 'network/core/types.dart';
import 'network/network_client.dart';
import 'version.dart';

const defaultUIConfigAssetPath = 'assets/json/dui_config.json';

class DigiaUIClient {
  static final DigiaUIClient _instance = DigiaUIClient._();

  DigiaUIClient._();

  static DigiaUIClient get instance => _instance;

  late String accessKey;
  late String baseUrl;
  late NetworkClient networkClient;
  late DUIConfig config;
  late DUIAppState appState;
  late int version;
  late Environment environment;
  late JSFunctions jsFunctions;
  late DUIAnalytics? duiAnalytics;
  static const appConfigFileName = 'appConfig.json';

  bool _isInitialized = false;

  static DUIConfig getConfigResolver() {
    return _instance.config;
  }

  static NetworkClient getNetworkClient() {
    return _instance.networkClient;
  }

  static bool isInitialized() {
    return _instance._isInitialized;
  }

  static void setUuid() {
    DUIApp.uuid = DUIPreferences.instance.getString('uuid');
    if (DUIApp.uuid == null) {
      DUIApp.uuid = const Uuid().v4();
      DUIPreferences.instance.setString('uuid', DUIApp.uuid!);
    }
  }

  static initializeFromData(
      {required String accessKey,
      required String baseUrl,
      required dynamic data,
      required NetworkConfiguration networkConfiguration,
      DeveloperConfig? developerConfig}) async {
    _instance.accessKey = accessKey;
    _instance.baseUrl = baseUrl;
    Map<String, dynamic> headers = {'digia_projectId': accessKey};
    _instance.networkClient = NetworkClient(
        _instance.baseUrl, headers, networkConfiguration, developerConfig);
    _instance.config = DUIConfig(data);

    await DUIPreferences.initialize();
    setUuid();

    _instance.appState = DUIAppState.fromJson(_instance.config.appState ?? {});

    _instance._isInitialized = true;
  }

  static initializeFromNetwork(
      {required String accessKey,
      required Environment environment,
      required int version,
      required String baseUrl,
      required NetworkConfiguration networkConfiguration,
      DeveloperConfig? developerConfig,
      DUIAnalytics? duiAnalytics}) async {
    await DUIPreferences.initialize();
    setUuid();
    BaseResponse resp;
    _instance.environment = environment;
    // _instance.version = version;
    _instance.accessKey = accessKey;
    _instance.baseUrl = baseUrl;
    _instance.duiAnalytics = duiAnalytics;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var packageName = packageInfo.packageName;
    var appVersion = packageInfo.version;
    var appbuildNumber = packageInfo.buildNumber;

    Map<String, dynamic> headers = {
      'x-digia-version': packageVersion,
      'x-digia-project-id': accessKey,
      'x-digia-platform': instance._getPlatform(),
      'x-digia-device-id': DUIApp.uuid,
      'x-app-package-name': packageName,
      'x-app-version': appVersion,
      'x-app-build-number': appbuildNumber
    };

    String requestPath;
    Map<String, dynamic>? storedAppConfig;
    switch (environment) {
      case Environment.staging:
        requestPath = '/config/getAppConfig';
        break;
      case Environment.production:
        requestPath = '/config/getAppConfigProduction';
        var appConfigdata = await readFileString(appConfigFileName);
        if (appConfigdata != null) {
          try {
            storedAppConfig =
                json.decode(appConfigdata) as Map<String, dynamic>?;
            var version = storedAppConfig?['response']['version'];
            headers['x-digia-project-version'] = version;
          } catch (e) {
            //do nothing
          }
        }
        break;
      case Environment.version:
        requestPath = '/config/getAppConfigForVersion';
        headers['x-digia-project-version'] = version;
        break;
      default:
        requestPath = '/config/getAppConfig';
    }

    _instance.networkClient = NetworkClient(
        _instance.baseUrl, headers, networkConfiguration, developerConfig);

    resp = await _instance.networkClient.requestInternal(
      HttpMethod.post,
      requestPath,
      (json) => json as dynamic,
    );

    final data = resp.data['response'] as Map<String, dynamic>?;

    if (storedAppConfig != null &&
        (data == null || data.isEmpty || data['versionUpdated'] == false)) {
      _instance.config = DUIConfig(storedAppConfig['response']);
    } else {
      if (data == null || data.isEmpty) {
        throw Exception(
          'Something went wrong while getting data from cloud, please check provided projectId',
        );
      }
      await writeStringToFile(json.encode(resp.data), appConfigFileName);
      _instance.config = DUIConfig(data);
    }

    if (_instance.config.functionsFilePath != null) {
      _instance.jsFunctions = JSFunctions();
      await _instance.jsFunctions
          .fetchJsFile(_instance.config.functionsFilePath!);
    }

    // _instance.jsFunctions.callJs('test3', {'number': 27});

    _instance.appState = DUIAppState.fromJson(_instance.config.appState ?? {});

    _instance._isInitialized = true;
  }

  static DigiaUIService createService() {
    return DigiaUIService(
        baseUrl: _instance.baseUrl,
        httpClient: _instance.networkClient,
        config: _instance.config);
  }

  Map<String, Object?> get jsVars => {
        'js': ExprClassInstance(
            klass: ExprClass(name: 'js', fields: {}, methods: {
          'eval': ExprCallableImpl(
              fn: (evaluator, arguments) {
                return _instance.jsFunctions.callJs(
                    _toValue<String>(evaluator, arguments[0])!,
                    arguments
                        .skip(1)
                        .map((e) => _toValue(evaluator, e))
                        .toList());
              },
              arity: 2)
        }))
      };

  T? _toValue<T>(evaluator, Object obj) {
    if (obj is ASTNode) {
      final result = evaluator.eval(obj);
      return result as T?;
    }

    return obj as T?;
  }

  String _getPlatform() {
    if (kIsWeb) return 'mobile_web';

    if (Platform.isIOS) return 'ios';

    if (Platform.isAndroid) return 'android';

    return 'mobile_web';
  }
}
