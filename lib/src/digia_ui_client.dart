import 'dart:convert';

import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/core/pref/dui_preferences.dart';
import 'package:digia_ui/src/models/dui_app_state.dart';
import 'package:digia_ui/src/network/api_response/base_response.dart';
import 'package:digia_ui/src/network/core/types.dart';
import 'package:digia_ui/src/network/network_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'digia_ui_service.dart';

const defaultUIConfigAssetPath = 'assets/json/dui_config.json';
const defaultBaseUrl = 'https://app.digia.tech/hydrator/api';
// const defaultBaseUrl = 'http://localhost:5000/hydrator/api';

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
  late String projectId;

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
      Dio? dio}) async {
    _instance.accessKey = accessKey;
    _instance.baseUrl = baseUrl ?? defaultBaseUrl;
    Map<String, dynamic> headers = {'digia_projectId': accessKey};
    _instance.networkClient = NetworkClient(dio, _instance.baseUrl, headers);
    final string =
        await rootBundle.loadString(assetPath ?? defaultUIConfigAssetPath);
    final data = jsonDecode(string);

    _instance.config = DUIConfig(data);

    await DUIPreferences.initialize();

    _instance.appState = DUIAppState.fromJson(_instance.config.appState ?? {});

    _instance._isInitialized = true;
  }

  static bool isInitialized() {
    return _instance._isInitialized;
  }

  static initializeFromData(
      {required String accessKey,
      String? baseUrl,
      Dio? dio,
      required dynamic data}) async {
    _instance.accessKey = accessKey;
    _instance.baseUrl = baseUrl ?? defaultBaseUrl;
    Map<String, dynamic> headers = {'digia_projectId': accessKey};
    _instance.networkClient = NetworkClient(dio, _instance.baseUrl, headers);
    _instance.config = DUIConfig(data);

    await DUIPreferences.initialize();

    _instance.appState = DUIAppState.fromJson(_instance.config.appState ?? {});

    _instance._isInitialized = true;
  }

  static initializeFromNetwork(
      {required String accessKey, required Environment environment, String? projectId, required int version, String? baseUrl, Dio? dio}) async {
    BaseResponse resp;
    _instance.environment = environment;
    _instance.projectId = projectId ?? '';
    _instance.version = version;
    _instance.accessKey = accessKey;
    _instance.baseUrl = baseUrl ?? defaultBaseUrl;
    Map<String, dynamic> headers = {'digia_projectId': accessKey};
    _instance.networkClient = NetworkClient(dio, _instance.baseUrl, headers);

    String requestPath;
    dynamic requestData;
    switch(environment) {
      case Environment.staging:
        requestPath = '/hydrator/api/config/getAppConfig';
        break;
      case Environment.production:
        requestPath = '/hydrator/api/config/getAppConfigProduction';
        break;
      case Environment.version:
        requestPath = '/hydrator/api/config/getAppConfigForVersion';
        requestData = jsonEncode(
          {'version': version},
        );
        break;
      default:
        requestPath = '/config/getAppConfig';
    }

    resp = await _instance.networkClient.request(
      method: HttpMethod.post,
      path: requestPath,
      headers: headers,
      fromJsonT: (json) => json as dynamic,
      data: requestData,
    );

    final data = resp.data['response'] as Map<String, dynamic>?;
    if (data == null || data.isEmpty) {
      throw Exception(
        'Something went wrong while getting data from cloud, please check provided projectId',
      );
    }

    _instance.config = DUIConfig(data);

    await DUIPreferences.initialize();

    _instance.appState = DUIAppState.fromJson(_instance.config.appState ?? {});

    _instance._isInitialized = true;
  }

  static DigiaUIService createService() {
    return DigiaUIService(
        baseUrl: _instance.baseUrl,
        httpClient: _instance.networkClient,
        config: _instance.config);
  }
}
