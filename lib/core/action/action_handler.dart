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
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';

class ActionHandler {
  static final ActionHandler _instance = ActionHandler._internal();

  factory ActionHandler() {
    return _instance;
  }

  Future<dynamic>? executeAction(
      BuildContext context, ActionProp action) async {
    switch (action.type) {
      case 'Action.navigateToPage':
        final pageName = action.data['slug'];

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
      case 'Action.loadPage':
        final pageName = action.data['slug'];
        if (pageName == null) {
          throw 'Target Page can not be null';
        }

        final response = await rootBundle.loadString('assets/json/config.json');
        final json = await jsonDecode(response) as Map<String, dynamic>;
        return json.valueFor(keyPath: 'pages.$pageName');

      case 'Action.renderSelf':
        final pageName = action.data['slug'];
        if (pageName == null) {
          throw 'Target Page can not be null';
        }

        final pageConfig = ConfigResolver().getPageConfig(pageName);

        if (pageConfig == null) {
          throw 'Page Config can not be null';
        }

        return pageConfig;

      case 'Action.restCall':
        return RestHandler().executeAction(context, action);

      case 'Action.pop':
        Navigator.of(context).maybePop();
        return null;

      case 'Action.openUrl':
        final url = Uri.parse(action.data['url']);
        final canOpenUrl = await canLaunchUrl(url);
        if (canOpenUrl == true) {
          await launchUrl(url,
              mode: DUIDecoder.toUriLaunchMode(action.data['launchMode']));
        }
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
