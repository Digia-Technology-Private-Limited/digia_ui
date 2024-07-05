import 'dart:developer';

import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:json_schema2/json_schema2.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/expr.dart';
import '../../Utils/extensions.dart';
import '../../components/dui_widget_scope.dart';
import '../../types.dart';
import '../analytics_handler.dart';
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
  'Action.rebuildPage': ({required action, required context, enclosing}) {
    final bloc = context.tryRead<DUIPageBloc>();
    bloc?.add(RebuildPageEvent(context));
    return null;
  },
  'Action.delay': ({required action, required context, enclosing}) async {
    final durationInMs = eval<double>(action.data['durationInMs'],
        context: context, enclosing: enclosing);

    if (durationInMs != null) {
      await Future.delayed(Duration(milliseconds: durationInMs.toInt()));
    } else {
      log('Wait Duration is null');
    }
  },
  'Action.navigateToPage': (
      {required action, required context, enclosing}) async {
    final String? pageUId = action.data['pageUid'] ?? action.data['pageId'];

    if (pageUId == null) {
      throw ArgumentError('Null value', 'pageId');
    }

    final String openAs =
        action.data['openAs'] ?? action.data['pageType'] ?? 'fullPage';
    final Map<String, dynamic> bottomSheetStyling = action.data['style'] ?? {};

    Map<String, dynamic>? pageArgs =
        action.data['pageArgs'] ?? action.data['args'];

    final pageProps =
        context.tryRead<DUIPageBloc>()?.config.getPageData(pageUId);
    final filteredArgs = ifNotNull(
        pageArgs?.entries
            .where((e) => pageProps?.inputArgs?[e.key] != null)
            .cast<MapEntry<String, dynamic>>(),
        Map<String, dynamic>.fromEntries);

    final evaluatedArgs = evalDynamic(filteredArgs, context, enclosing);

    final widgetScope = DUIWidgetScope.maybeOf(context);

    final waitForResult =
        NumDecoder.toBool(action.data['waitForResult']) ?? false;
    Object? result;

    switch (openAs) {
      case 'bottomSheet':
        result = await openDUIPageInBottomSheet(
          pageUid: pageUId,
          context: context,
          style: bottomSheetStyling,
          pageArgs: evaluatedArgs,
          iconDataProvider: widgetScope?.iconDataProvider,
          imageProviderFn: widgetScope?.imageProviderFn,
          textStyleBuilder: widgetScope?.textStyleBuilder,
          onMessageReceived: widgetScope?.onMessageReceived,
        );
      case 'fullPage' || _:
        final removePreviousScreensInStack = NumDecoder.toBoolOrDefault(
            action.data['shouldRemovePreviousScreensInStack'],
            defaultValue: false);
        final routeNametoRemoveUntil = eval<String>(
            action.data['routeNametoRemoveUntil'],
            context: context,
            enclosing: enclosing);

        result = await NavigatorHelper.push(
            context,
            DUIPageRoute(
              pageUid: pageUId,
              context: context,
              pageArgs: evaluatedArgs,
              iconDataProvider: widgetScope?.iconDataProvider,
              imageProviderFn: widgetScope?.imageProviderFn,
              textStyleBuilder: widgetScope?.textStyleBuilder,
              onMessageReceived: widgetScope?.onMessageReceived,
            ),
            removeRoutesUntilPredicate: routeNametoRemoveUntil.letIf(
                (_) => removePreviousScreensInStack,
                (p0) => ModalRoute.withName(p0)));
    }
    if (waitForResult && context.mounted) {
      final onResultActionflow = ActionFlow.fromJson(action.data['onResult']);
      await ActionHandler.instance.execute(
          context: context,
          actionFlow: onResultActionflow,
          enclosing: ExprContext(variables: {
            'result': result,
          }, enclosing: enclosing));
    }
    return result;
  },
  'Action.pop': ({required action, required context, enclosing}) {
    final maybe = eval<bool>(action.data['maybe'],
            context: context, enclosing: enclosing) ??
        false;

    final result =
        eval(action.data['result'], context: context, enclosing: enclosing);

    if (maybe) {
      return Navigator.of(context).maybePop(result);
    }

    Navigator.of(context).pop(result);
    return null;
  },
  'Action.popUntil': ({required action, required context, enclosing}) {
    final routeNametoPopUntil = eval<String>(action.data['routeNameToPopUntil'],
        context: context, enclosing: enclosing);
    if (routeNametoPopUntil == null) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.popUntil(context, ModalRoute.withName(routeNametoPopUntil));
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
  'Action.controlDrawer': ({required action, required context, enclosing}) {
    final choice = eval<String>(action.data['choice'],
        context: context, enclosing: enclosing);
    final scaffold = Scaffold.maybeOf(context);
    if (choice == 'openDrawer') {
      scaffold?.openDrawer();
    } else if (choice == 'openEndDrawer') {
      scaffold?.openEndDrawer();
    } else {
      scaffold?.closeDrawer();
      scaffold?.closeEndDrawer();
    }
    return;
  },
  'Action.showToast': ({required action, required context, enclosing}) {
    final message = eval<String>(action.data['message'],
        context: context, enclosing: enclosing);
    final duration = eval<int>(action.data['duration'],
        context: context, enclosing: enclosing);

    final toast = FToast().init(context);
    toast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.black,
        ),
        child: Text(
          message ?? '',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: duration ?? 2),
    );
    return;
  },
  'Action.handleDigiaMessage': (
      {required action, required context, enclosing}) {
    final handler = DUIWidgetScope.maybeOf(context)?.onMessageReceived;
    if (handler == null) return;

    final name = action.data['name'];
    final body = action.data['body'];

    handler(MessagePayload(
        context: context,
        name: name,
        body: evalDynamic(body, context, enclosing)));

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
      final variableDefs = bloc.state.props.variables;

      bloc.add(SetStateEvent(
          events: events
              .where((e) => variableDefs?[e['variableName']] != null)
              .map((e) => SingleSetStateEvent(
                  variableName: e['variableName'],
                  context: context,
                  value: evalDynamic(
                    e['value'],
                    context,
                    enclosing,
                  )))
              .toList(),
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
  },
};

class ActionHandler {
  static final ActionHandler _instance = ActionHandler._();

  ActionHandler._();

  static ActionHandler get instance => _instance;

  Future<dynamic>? execute(
      {required BuildContext context,
      required ActionFlow actionFlow,
      ExprContext? enclosing}) async {
    AnalyticsHandler.instance.execute(
        context: context,
        events: actionFlow.analyticsData,
        enclosing: enclosing);

    for (final action in actionFlow.actions) {
      final executable = _actionsMap[action.type];

      if (!context.mounted) continue;

      final disableAction = eval<bool>(action.disableActionIf,
          context: context, enclosing: enclosing);

      if (executable == null || disableAction == true) {
        continue;
      }

      await executable.call(
          context: context, action: action, enclosing: enclosing);
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

abstract class NavigatorHelper {
  static Future<T?> push<T extends Object?>(
      BuildContext context, Route<T> newRoute,
      {RoutePredicate? removeRoutesUntilPredicate}) {
    if (removeRoutesUntilPredicate == null) {
      return Navigator.push<T>(context, newRoute);
    }

    return Navigator.pushAndRemoveUntil<T>(
        context, newRoute, removeRoutesUntilPredicate);
  }
}
