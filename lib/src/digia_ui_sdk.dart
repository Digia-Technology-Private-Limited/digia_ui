import 'package:digia_ui/src/Utils/config_resolver.dart';
import 'package:digia_ui/src/core/page/dui_page.dart';
import 'package:digia_ui/src/core/page/dui_page_bloc.dart';
import 'package:digia_ui/src/core/page/dui_page_event.dart';
import 'package:digia_ui/src/core/page/dui_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const defaultUIConfigAssetPath = 'assets/json/dui_config.json';

class DigiaUiSDk {
  static final DigiaUiSDk _instance = DigiaUiSDk._();

  DigiaUiSDk._();

  late String accessKey;

  bool _isInitialized = false;

  static initialize(
      {required String accessKey, String? assetPath, String? baseUrl}) async {
    _instance.accessKey = accessKey;

    await DigiaUIConfig.initialize(assetPath ?? defaultUIConfigAssetPath);

    _instance._isInitialized = true;
  }

  static bool isInitialized() {
    return _instance._isInitialized;
  }

  static initializeByJson({dynamic json}) async {
    // Perform SDK initialization tasks here
    // This could include setting up configurations, initializing services, etc.
    // Load configuration
    await DigiaUIConfig.initializeByJson(json);
    // await PrefUtil.init();
  }

  static initializeFromCloud({required String accessKey}) async {
    bool res = await DigiaUIConfig.initializeFromCloud(accessKey);
    if (!res) {
      throw Exception(
        'Something went wrong while getting data from cloud, please check provided projectId',
      );
    }
  }

  static Widget getPage({
    Map<String, dynamic>? args,
    Function({String actionId, List<dynamic> data})? function,
    required String pageUid,
  }) {
    return BlocProvider(
      create: (context) {
        DigiaUIConfig resolver = DigiaUIConfig();
        return DUIPageBloc(
            initData: DUIPageInitData(
                identifier: pageUid, config: resolver.getPageConfig(pageUid)!),
            resolver: resolver)
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
