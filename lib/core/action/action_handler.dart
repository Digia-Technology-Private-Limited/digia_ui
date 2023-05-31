import 'dart:convert';

import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/Utils/extensions.dart';
import 'package:digia_ui/core/action/action_prop.dart';
import 'package:digia_ui/core/page/dui_page.dart';
import 'package:digia_ui/core/page/page_init_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActionHandler {
  static final ActionHandler _instance = ActionHandler._internal();

  factory ActionHandler() {
    return _instance;
  }

  Future<dynamic>? executeAction(
      BuildContext context, ActionProp action) async {
    switch (action.type) {
      case 'navigate_to_page':
        final pageName = action.data['pageName'];

        if (pageName == null) {
          throw "Target Page can not be null";
        }

        final pageConfig = ConfigResolver().getPageConfig(pageName);

        if (pageConfig == null) {
          throw "Page Config can not be null";
        }

        return Navigator.push(context, MaterialPageRoute(builder: (ctx) {
          return DUIPage(
              initData: PageInitData(
                  pageName: pageName,
                  pageConfig: pageConfig,
                  inputArgs: action.data['inputArgs']));
        }));

      // TODO: Replace file read by API Call.
      case 'loadPage':
        final pageName = action.data['pageName'];
        if (pageName == null) {
          throw "Target Page can not be null";
        }

        final response = await rootBundle.loadString("assets/json/config.json");
        final json = await jsonDecode(response) as Map<String, dynamic>;
        return json.valueFor(keyPath: "pages.$pageName");

      case 'renderLayout':
        final pageName = action.data['pageName'];
        if (pageName == null) {
          throw "Target Page can not be null";
        }

        final pageConfig = ConfigResolver().getPageConfig(pageName);

        if (pageConfig == null) {
          throw "Page Config can not be null";
        }

        return pageConfig;
    }

    return null;
  }

  ActionHandler._internal();
}
