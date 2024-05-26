import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/extensions.dart';
import '../../components/dui_widget_scope.dart';
import '../../types.dart';
import '../app_state_provider.dart';
import '../evaluator.dart';
import '../page/dui_page_bloc.dart';
import '../page/dui_page_event.dart';
import '../utils.dart';
import 'action_prop.dart';

typedef ActionHandlerFn = Future<dynamic>? Function({
  required BuildContext context,
  required ActionProp action,
  ExprContext? enclosing,
});

Map<String, ActionHandlerFn> _actionsMap = {
  'Action.navigateToPage': ({required action, required context, enclosing}) {
    final String? pageUId = action.data['pageUid'] ?? action.data['pageId'];

    if (pageUId == null) {
      throw 'Page Id not found in Action Props';
    }

    final String openAs =
        action.data['openAs'] ?? action.data['pageType'] ?? 'fullPage';
    final Map<String, dynamic> bottomSheetStyling = action.data['style'] ?? {};

    Map<String, dynamic>? pageArgs =
        action.data['pageArgs'] ?? action.data['args'];

    final evaluatedArgs = _eval(pageArgs, context, enclosing);

    return switch (openAs) {
      'bottomSheet' => openDUIPageInBottomSheet(
          pageUid: pageUId, context: context, style: bottomSheetStyling),
      'fullPage' || _ => openDUIPage(
          pageUid: pageUId, context: context, pageArgs: evaluatedArgs),
    };
  },
  // 'Action.navigateToPageNameInBottomSheet': (
  //     {required action, required context}) {
  //   final String? pageUId = action.data['pageUId'] ?? action.data['pageId'];
  //
  //   if (pageUId == null) {
  //     throw 'Page Id not found in Action Props';
  //   }
  //   final pageArgs = action.data['pageArgs'] ?? action.data['args'];
  //   return openDUIPageInBottomSheet(
  //       pageUid: pageUId, context: context, pageArgs: pageArgs);
  // },
  'Action.pop': ({required action, required context, enclosing}) {
    if (action.data['maybe'] == true) {
      Navigator.of(context).maybePop();
      return;
    }

    Navigator.of(context).pop();
    return;
  },
  'Action.openUrl': ({required action, required context, enclosing}) async {
    final url =
        eval<String>(action.data['url'], context: context, enclosing: enclosing)
            .let(Uri.parse);
    final canOpenUrl = url != null && await canLaunchUrl(url);
    if (canOpenUrl) {
      return launchUrl(url,
          mode: DUIDecoder.toUriLaunchMode(action.data['launchMode']));
    } else {
      throw 'Not allowed to open url: $url';
    }
  },
  'Action.handleDigiaMessage': (
      {required action, required context, enclosing}) {
    final handler = DUIWidgetScope.maybeOf(context)?.onMessageReceived;
    if (handler == null) return;

    final name = action.data['name'];
    final body = action.data['body'];

    handler(MessagePayload(
        context: context, name: name, body: _eval(body, context, enclosing)));

    Navigator.of(context).pop();
    return;
  },
  'Action.setPageState': ({required action, required context, enclosing}) {
    final bloc = context.tryRead<DUIPageBloc>();
    if (bloc == null) {
      throw 'Action.setPageState called on a widget which is not wrapped in DUIPageBloc';
    }

    final events = action.data['events'];
    final bool rebuildPage =
        NumDecoder.toBool(action.data['rebuildPage']) ?? true;

    if (events is List) {
      bloc.add(SetStateEvent(
          events: events.map((e) {
            final value = eval(
              e['value'],
              context: context,
              enclosing: enclosing,
              decoder: (p0) => p0,
            );
            return SingleSetStateEvent(
                variableName: e['variableName'],
                context: context,
                value: value);
          }).toList(),
          rebuildPage: rebuildPage));
    }

    return;
  },
  'Action.setAppState': ({required action, required context, enclosing}) {
    final events = action.data['events'];

    if (events is List) {
      for (final e in events) {
        final value = eval(
          e['value'],
          context: context,
          enclosing: enclosing,
          decoder: (p0) => p0,
        );
        AppStateProvider.maybeOf(context)?.setState(e['variableName'], value);
      }

      context
          .tryRead<DUIPageBloc>()
          ?.add(SetStateEvent(events: [], rebuildPage: true));

      return;
    }
    return null;
  }
};

class ActionHandler {
  static final ActionHandler _instance = ActionHandler._();

  ActionHandler._();

  static ActionHandler get instance => _instance;

  Future<dynamic>? execute(
      {required BuildContext context,
      required ActionFlow actionFlow,
      ExprContext? enclosing}) async {
    for (final action in actionFlow.actions) {
      final executable = _actionsMap[action.type];
      if (executable == null) {
        if (kDebugMode) {
          print('Action of type ${action.type} not found');
        }
        continue;
      }
      executable.call(context: context, action: action, enclosing: enclosing);
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

_eval(dynamic pageArgs, BuildContext context, ExprContext? enclosing) {
  if (pageArgs == null) return null;

  if (pageArgs is String || pageArgs is num || pageArgs is bool) {
    return eval(pageArgs, context: context, enclosing: enclosing);
  }

  if (pageArgs is Map<String, dynamic>) {
    return pageArgs
        .map((key, value) => MapEntry(key, _eval(value, context, enclosing)));
  }

  if (pageArgs is List) {
    return pageArgs.map((e) => _eval(e, context, enclosing));
  }

  return null;
}
