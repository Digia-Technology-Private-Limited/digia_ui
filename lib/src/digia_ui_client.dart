import 'dart:io';

import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../digia_ui.dart';
import 'core/functions/js_functions.dart';
import 'framework/state/state_context.dart';
import 'network/network_client.dart';
import 'preferences.dart';
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
  late int version;
  late Environment environment;
  late Flavor flavor;
  late JSFunctions jsFunctions;
  late DUIAnalytics? duiAnalytics;
  late DeveloperConfig? developerConfig;
  late String? uuid;
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
    var uuid = DUIPreferences.instance.getString('uuid');
    if (uuid == null) {
      uuid = const Uuid().v4();
      DUIPreferences.instance.setString('uuid', uuid);
    }
    DigiaUIClient.instance.uuid = uuid;
  }

  static Future<void> initializeFromData(
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

    // _instance.appState = DUIAppState.fromJson(_instance.config.appState ?? {});

    _instance._isInitialized = true;
  }

  static Future<void> init(
      {required String accessKey,
      required FlavorInfo flavorInfo,
      required String environment,
      required String baseUrl,
      required NetworkConfiguration networkConfiguration,
      DeveloperConfig? developerConfig,
      DUIAnalytics? duiAnalytics}) async {
    await DUIPreferences.initialize();
    setUuid();
    _instance.flavor = flavorInfo.flavor;
    _instance.accessKey = accessKey;
    _instance.baseUrl = baseUrl;
    _instance.duiAnalytics = duiAnalytics;
    _instance.developerConfig = developerConfig;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var packageName = packageInfo.packageName;
    var appVersion = packageInfo.version;
    var appbuildNumber = packageInfo.buildNumber;

    AppConfigResolver appConfigResolver = AppConfigResolver(flavorInfo);

    Map<String, dynamic> headers = NetworkClient.getDefaultDigiaHeaders(
        packageVersion,
        accessKey,
        instance._getPlatform(),
        instance.uuid,
        packageName,
        appVersion,
        appbuildNumber,
        environment);

    _instance.networkClient = NetworkClient(
        _instance.baseUrl, headers, networkConfiguration, developerConfig);

    _instance.config = await appConfigResolver.getConfig();

    // _instance.appState = DUIAppState.fromJson(_instance.config.appState ?? {});

    if (developerConfig?.inspector?.stateObserver != null) {
      StateContext.observer = developerConfig?.inspector?.stateObserver;
    }

    _instance._isInitialized = true;
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
