import 'dart:convert';

import 'package:digia_ui/src/config_resolver.dart';
import 'package:digia_ui/src/network/network_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'digia_ui_service.dart';

const defaultUIConfigAssetPath = 'json/config.json';
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

    _instance._isInitialized = true;
  }

  static initializeFromNetwork(
      {required String accessKey, String? baseUrl, Dio? dio}) async {
    _instance.accessKey = accessKey;
    _instance.baseUrl = baseUrl ?? defaultBaseUrl;
    Map<String, dynamic> headers = {'digia_projectId': accessKey};
    _instance.networkClient = NetworkClient(dio, _instance.baseUrl, headers);

    // final file = File('config.json');
    // if (!file.existsSync()) {
    // file.createSync();
    // }

    final resp = await _instance.networkClient.post(
      path: '/config/getAppConfig',
      fromJsonT: (json) => json as dynamic,
      data: jsonEncode(
        {'projectId': accessKey},
      ),
    );

    final data = resp.data['response'] as Map<String, dynamic>?;
    if (data == null || data.isEmpty) {
      throw Exception(
        'Something went wrong while getting data from cloud, please check provided projectId',
      );
    }

    // await file.writeAsString(jsonEncode(data));
    // final localConfig = jsonDecode(await file.readAsString());
    // // Version Matching
    // if (localConfig['version'] != data['version']) {
    //   await file.writeAsString(jsonEncode(data));
    // }
    _instance.config = DUIConfig(data);
    _instance._isInitialized = true;
  }

  static DigiaUIService createService() {
    return DigiaUIService(
        baseUrl: _instance.baseUrl,
        httpClient: _instance.networkClient,
        config: _instance.config);
  }
}
