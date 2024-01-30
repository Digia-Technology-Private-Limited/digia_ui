import 'package:digia_ui/src/Utils/config_resolver.dart';
import 'package:digia_ui/src/core/page/dui_page.dart';
import 'package:digia_ui/src/core/page/dui_page_bloc.dart';
import 'package:digia_ui/src/core/page/dui_page_event.dart';
import 'package:digia_ui/src/core/page/dui_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DigiaUiSDk {
  final String projectId;

  DigiaUiSDk({required this.projectId});

  static initialize({required String assetPath}) async {
    // Perform SDK initialization tasks here
    // This could include setting up configurations, initializing services, etc.
    // Load configuration
    await ConfigResolver.initialize(assetPath);
    // await PrefUtil.init();
  }

  static initializeByJson({dynamic json}) async {
    // Perform SDK initialization tasks here
    // This could include setting up configurations, initializing services, etc.
    // Load configuration
    await ConfigResolver.initializeByJson(json);
    // await PrefUtil.init();
  }

  initializeFromCloud() async {
    bool res = await ConfigResolver.initializeFromCloud(projectId);
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
        ConfigResolver resolver = ConfigResolver();
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
