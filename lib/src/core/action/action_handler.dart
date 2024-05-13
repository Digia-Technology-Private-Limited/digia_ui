import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/extensions.dart';
import '../../components/dui_widget_scope.dart';
import '../app_state_provider.dart';
import '../evaluator.dart';
import '../page/dui_page_bloc.dart';
import '../page/dui_page_event.dart';
import '../utils.dart';
import 'action_prop.dart';

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

    final pageArgs = action.data['pageArgs'] ?? action.data['args'];

    return openDUIPage(pageUid: pageUId, context: context, pageArgs: pageArgs);
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
    final handler = DUIWidgetScope.maybeOf(context)?.externalFunctionHandler;
    if (handler == null) return;

    handler(context, action.data['methodId'], action.data['args']);
    return;
  },
  'Action.setPageState': ({required action, required context}) {
    final bloc = context.tryRead<DUIPageBloc>();
    if (bloc == null) {
      throw 'Action.setPageState called on a widget which is not wrapped in DUIPageBloc';
    }

    final events = action.data['events'];

    if (events is List) {
      bloc.add(SetStateEvent(
          events: events.map((e) {
        final value = eval(
          e['value'],
          context: context,
          decoder: (p0) => p0,
        );
        return SingleSetStateEvent(
            variableName: e['variableName'], context: context, value: value);
      }).toList()));
    }

    return;
  },
  'Action.setAppState': ({required action, required context}) {
    final events = action.data['events'];

    if (events is List) {
      for (final e in events) {
        final value = eval(
          e['value'],
          context: context,
          decoder: (p0) => p0,
        );
        AppStateProvider.maybeOf(context)?.setState(e['variableName'], value);
      }

      context.tryRead<DUIPageBloc>()?.add(SetStateEvent(events: []));

      return;
    }
    return null;
  }
};

class ActionHandler {
  static final ActionHandler _instance = ActionHandler._();

  ActionHandler._();

  static ActionHandler get instance => _instance;

  Future<dynamic>? execute({
    required BuildContext context,
    required ActionFlow actionFlow,
  }) async {
    for (final action in actionFlow.actions) {
      final executable = _actionsMap[action.type];
      if (executable == null) {
        if (kDebugMode) {
          print('Action of type ${action.type} not found');
        }
        continue;
      }

      executable(context: context, action: action);
    }

    return null;
  }
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
