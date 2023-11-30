import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/core/action/action_prop.dart';
import 'package:digia_ui/core/action/rest_handler.dart';
import 'package:flutter/material.dart';
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

      // return Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      //   return DUIPage(
      //       initData: DUIPageInitData(
      //           pageName: pageName,
      //           pageConfig: pageConfig,
      //           inputArgs: inputArgs));
      // }));

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
