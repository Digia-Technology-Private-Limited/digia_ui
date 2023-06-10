import 'dart:convert';

import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/Utils/extensions.dart';
import 'package:digia_ui/core/action/action_prop.dart';
import 'package:digia_ui/core/action/rest_handler.dart';
import 'package:digia_ui/core/page/dui_page.dart';
import 'package:digia_ui/core/page/page_init_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_schema2/json_schema2.dart';

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
          throw 'Target Page can not be null';
        }

        final pageConfig = ConfigResolver().getPageConfig(pageName);

        if (pageConfig == null) {
          throw 'Page Config can not be null';
        }

        final inputArgs = action.data['inputArgs'];

        validateSchema(inputArgs, pageConfig['inputArgs']);

        return Navigator.push(context, MaterialPageRoute(builder: (ctx) {
          return DUIPage(
              initData: PageInitData(
                  pageName: pageName,
                  pageConfig: pageConfig,
                  inputArgs: inputArgs));
        }));

      // TODO: Replace file read by API Call.
      case 'loadPage':
        final pageName = action.data['pageName'];
        if (pageName == null) {
          throw 'Target Page can not be null';
        }

        final response = await rootBundle.loadString('assets/json/config.json');
        final json = await jsonDecode(response) as Map<String, dynamic>;
        return json.valueFor(keyPath: 'pages.$pageName');

      case 'renderLayout':
        final pageName = action.data['pageName'];
        if (pageName == null) {
          throw 'Target Page can not be null';
        }

        final pageConfig = ConfigResolver().getPageConfig(pageName);

        if (pageConfig == null) {
          throw 'Page Config can not be null';
        }

        return pageConfig;

      case 'rest_call':
        return RestHandler().executeAction(context, action);
    }

    return null;
  }

  ActionHandler._internal();
}

bool validateSchema(Map<String, dynamic>? args, Map<String, dynamic> def) {
  final schema = JsonSchema.createSchema(def);
  final validationResult = schema.validate(args);
  if (!validationResult) {
    throw 'Validation Error';
  }

  return true;
}

const Map<String, String> defaultHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};
