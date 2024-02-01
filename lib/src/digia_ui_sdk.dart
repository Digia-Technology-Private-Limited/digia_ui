import 'dart:convert';

import 'package:digia_ui/src/config_resolver.dart';
import 'package:digia_ui/src/core/page/dui_page.dart';
import 'package:digia_ui/src/core/page/dui_page_bloc.dart';
import 'package:digia_ui/src/core/page/dui_page_event.dart';
import 'package:digia_ui/src/core/page/dui_page_state.dart';
import 'package:digia_ui/src/network/network_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'digia_ui_service.dart';

const defaultUIConfigAssetPath = 'assets/json/dui_config.json';
const defaultBaseUrl = 'https://app.digia.tech/hydrator/api';
// const baseUrl = 'http://localhost:5000/hydrator/api';

class DigiaUIClient {
  static final DigiaUIClient _instance = DigiaUIClient._();

  DigiaUIClient._();

  late String accessKey;
  late String baseUrl;
  late NetworkClient networkClient;
  late DigiaUIConfigResolver configResolver;

  bool _isInitialized = false;

  static DigiaUIConfigResolver getConfigResolver() {
    return _instance.configResolver;
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
    _instance.networkClient = NetworkClient(dio, _instance.baseUrl);
    final string =
        await rootBundle.loadString(assetPath ?? defaultUIConfigAssetPath);
    final data = jsonDecode(string);

    _instance.configResolver = DigiaUIConfigResolver(data);

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
    _instance.networkClient = NetworkClient(dio, _instance.baseUrl);
    _instance.configResolver = DigiaUIConfigResolver(data);

    _instance._isInitialized = true;
  }

  static initializeFromNetwork(
      {required String accessKey, String? baseUrl, Dio? dio}) async {
    _instance.accessKey = accessKey;
    _instance.baseUrl = baseUrl ?? defaultBaseUrl;
    _instance.networkClient = NetworkClient(dio, _instance.baseUrl);

    final resp = await _instance.networkClient.post(
        path: '${_instance.baseUrl}/config/getAppConfig',
        fromJsonT: (json) => json as dynamic,
        data: jsonEncode({'projectId': accessKey}));

    final data = resp.data['response'] as Map<String, dynamic>?;
    if (data == null || data.isEmpty) {
      throw Exception(
        'Something went wrong while getting data from cloud, please check provided projectId',
      );
    }

    _instance.configResolver = DigiaUIConfigResolver(data);
    _instance._isInitialized = true;
  }

  static DigiaUIService createService() {
    return DigiaUIService(
        baseUrl: _instance.baseUrl,
        httpClient: _instance.networkClient,
        config: _instance.configResolver);
  }

  static Widget getPage({
    Map<String, dynamic>? args,
    Function({String actionId, List<dynamic> data})? function,
    required String pageUid,
  }) {
    return BlocProvider(
      create: (context) {
        return DUIPageBloc(
            initData: DUIPageInitData(
                identifier: pageUid,
                config: _instance.configResolver.getPageConfig(pageUid)!),
            resolver: _instance.configResolver)
          ..add(
            InitPageEvent(),
          );
      },
      child: const DUIPage(),
    );
  }

  static openPage({
    required String pageUid,
    required BuildContext context,
    Map<String, dynamic>? args,
    Function({String actionId, List<dynamic> data})? function,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return getPage(
            pageUid: pageUid,
            args: args,
            function: function,
          );
        },
      ),
    );
  }
}
