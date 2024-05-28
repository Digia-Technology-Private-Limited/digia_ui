import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../digia_ui.dart';
import 'core/pref/dui_preferences.dart';
import 'digia_ui_service.dart';
import 'models/dui_app_state.dart';
import 'network/api_response/base_response.dart';
import 'network/core/types.dart';
import 'network/network_client.dart';

const defaultUIConfigAssetPath = 'assets/json/dui_config.json';
const defaultBaseUrl = 'https://app.digia.tech/api/v1';
// const defaultBaseUrl = 'http://localhost:3000/api/v1';

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
  late DUIAnalytics? duiAnalytics;

  bool _isInitialized = false;

  static DUIConfig getConfigResolver() {
    return _instance.config;
  }

  static NetworkClient getNetworkClient() {
    return _instance.networkClient;
  }

  static initialize(
      {required String accessKey,
      String? assetPath,
      String? baseUrl,
      required NetworkConfiguration networkConfiguration}) async {
    _instance.accessKey = accessKey;
    _instance.baseUrl = baseUrl ?? defaultBaseUrl;
    Map<String, dynamic> headers = {'digia_projectId': accessKey};
    _instance.networkClient =
        NetworkClient(_instance.baseUrl, headers, networkConfiguration, null);
    final string =
        await rootBundle.loadString(assetPath ?? defaultUIConfigAssetPath);
    final data = jsonDecode(string);

    _instance.config = DUIConfig(data);

    await DUIPreferences.initialize();
    setUuid();

    _instance.appState = DUIAppState.fromJson(_instance.config.appState ?? {});

    _instance._isInitialized = true;
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
      String? baseUrl,
      required dynamic data,
      required NetworkConfiguration networkConfiguration,
      DeveloperConfig? developerConfig}) async {
    _instance.accessKey = accessKey;
    _instance.baseUrl = baseUrl ?? defaultBaseUrl;
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
      String? projectId,
      required int version,
      String? baseUrl,
      required NetworkConfiguration networkConfiguration,
      DeveloperConfig? developerConfig,
      DUIAnalytics? duiAnalytics}) async {
    await DUIPreferences.initialize();
    setUuid();
    BaseResponse resp;
    _instance.environment = environment;
    _instance.version = version;
    _instance.accessKey = accessKey;
    _instance.baseUrl = baseUrl ?? defaultBaseUrl;
    _instance.duiAnalytics = duiAnalytics;

    Map<String, dynamic> apiParams = {
      'digia_projectId': accessKey,
      'projectId': accessKey,
      'version': version,
      'platform': instance._getPlatform(),
      'deviceId': DUIApp.uuid
    };
    _instance.networkClient = NetworkClient(
        _instance.baseUrl, apiParams, networkConfiguration, developerConfig);

    String requestPath;
    dynamic requestData;
    switch (environment) {
      case Environment.staging:
        requestPath = '/config/getAppConfig';
        requestData = jsonEncode(apiParams);
        break;
      case Environment.production:
        requestPath = '/config/getAppConfigProduction';
        requestData = jsonEncode(apiParams);
        break;
      case Environment.version:
        requestPath = '/config/getAppConfigForVersion';
        requestData = jsonEncode(apiParams);
        break;
      default:
        requestPath = '/config/getAppConfig';
        requestData = jsonEncode(apiParams);
    }

    resp = await _instance.networkClient.requestInternal(
      HttpMethod.post,
      requestPath,
      headers: apiParams,
      (json) => json as dynamic,
      data: requestData,
    );

    final data = resp.data['response'] as Map<String, dynamic>?;
    if (data == null || data.isEmpty) {
      throw Exception(
        'Something went wrong while getting data from cloud, please check provided projectId',
      );
    }

    _instance.config = DUIConfig(data);

    _instance.appState = DUIAppState.fromJson(_instance.config.appState ?? {});

    _instance._isInitialized = true;
  }

  static DigiaUIService createService() {
    return DigiaUIService(
        baseUrl: _instance.baseUrl,
        httpClient: _instance.networkClient,
        config: _instance.config);
  }

  String _getPlatform() {
    if (kIsWeb) return 'mobile_web';

    if (Platform.isIOS) return 'ios';

    if (Platform.isAndroid) return 'android';

    return 'mobile_web';
  }
}
