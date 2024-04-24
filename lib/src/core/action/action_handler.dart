import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/extensions.dart';
import 'package:digia_ui/src/core/action/action_prop.dart';
import 'package:digia_ui/src/core/page/dui_page_bloc.dart';
import 'package:digia_ui/src/core/page/dui_page_event.dart';
import 'package:digia_ui/src/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';

typedef ActionHandlerFn = Future<dynamic>? Function({
  required BuildContext context,
  required ActionProp action,
});

Map<String, ActionHandlerFn> _actionsMap = {
  'Action.navigateToPage': ({required action, required context}) {
    final String? pageUId = action.data['pageUId'] ?? action.data['pageId'];

    if (pageUId == null) {
      throw 'Page Id not found in Action Props';
    }

    return openDUIPage(
        pageUid: pageUId, context: context, pageArgs: action.data['pageArgs']);
  },
  'Action.pop': ({required action, required context}) {
    if (action.data['maybe'] == true) {
      Navigator.of(context).maybePop();
      return;
    }

    Navigator.of(context).pop();
    return;
  },
  'Action.openUrl': ({required action, required context}) async {
    final url = Uri.parse(action.data['url']);
    final canOpenUrl = await canLaunchUrl(url);
    if (canOpenUrl) {
      return launchUrl(url,
          mode: DUIDecoder.toUriLaunchMode(action.data['launchMode']));
    } else {
      throw 'Not allowed to open url: $url';
    }
  },
  'Action.callExternalFunction': ({required action, required context}) {
    final handler = DUIWidgetScope.of(context)?.externalFunctionHandler;
    if (handler == null) return;

    handler(context, action.data['methodId'], action.data['args']);
    return;
  },
  'Action.setPageState': ({required action, required context}) {
    final bloc = context.tryRead<DUIPageBloc>();
    if (bloc == null) {
      throw 'Action.setPageState called on a widget which is not wrapped in DUIPageBloc';
    }

    bloc.add(SetStateEvent(
        variableName: action.data['variableName'],
        context: context,
        value: action.data['value']));
    return;
  },
  'Action.showAlertDialog': ({required action, required context}) {
    return showAlertDialog(
        context: context,
        title: action.data['title'],
        content: action.data['content']);
  },
};

class ActionHandler {
  static final ActionHandler _instance = ActionHandler._();

  ActionHandler._();

  static ActionHandler get instance => _instance;

  Future<dynamic>? execute({
    required BuildContext context,
    required ActionProp action,
  }) async {
    final executable = _actionsMap[action.type];
    if (executable == null) {
      print('Action of type ${action.type} not found');
      return;
    }

    return executable(context: context, action: action);
  }

  // Future<dynamic>? executeAction(
  //     BuildContext context, ActionProp action) async {
  //   switch (action.type) {
  //     case 'Action.restCall':
  //       return RestHandler().executeAction(context, action);

  //   }

  //   return null;
  // }
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
