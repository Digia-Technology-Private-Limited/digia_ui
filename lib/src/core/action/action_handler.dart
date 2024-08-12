import 'dart:developer';

import 'package:digia_expr/digia_expr.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/expr.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../../components/DUIText/dui_text_style.dart';
import '../../components/dui_widget_scope.dart';
import '../../models/dui_file.dart';
import '../../types.dart';
import '../analytics_handler.dart';
import '../app_state_provider.dart';
import '../evaluator.dart';
import '../page/dui_page_bloc.dart';
import '../page/dui_page_event.dart';
import '../utils.dart';
import 'action_prop.dart';
import 'api_handler.dart';

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
          navigatorKey: widgetScope?.navigatorKey,
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
            widgetScope?.navigatorKey,
            DUIPageRoute(
                pageUid: pageUId,
                context: context,
                pageArgs: evaluatedArgs,
                iconDataProvider: widgetScope?.iconDataProvider,
                imageProviderFn: widgetScope?.imageProviderFn,
                textStyleBuilder: widgetScope?.textStyleBuilder,
                onMessageReceived: widgetScope?.onMessageReceived,
                navigatorKey: widgetScope?.navigatorKey),
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

    final result = evalDynamic(action.data['result'], context, enclosing);

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
    final Map<String, dynamic>? style = action.data['style'] ?? {};
    final Color? bgColor = makeColor(style?['bgColor']);
    final borderRadius =
        DUIDecoder.toBorderRadius(style?['borderRadius'] ?? '12, 12, 12, 12');
    final TextStyle? textStyle =
        toTextStyle(DUITextStyle.fromJson(style?['textStyle']), context);
    final height = eval<double>(style?['height'], context: context);
    final width = eval<double>(style?['width'], context: context);
    final padding =
        DUIDecoder.toEdgeInsets(style?['padding'] ?? '24, 12, 24, 12');
    final margin = DUIDecoder.toEdgeInsets(style?['margin']);
    final alignment = DUIDecoder.toAlignment(style?['alignment']);

    final toast = FToast().init(context);
    toast.showToast(
      child: Container(
        alignment: alignment,
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: bgColor ?? Colors.black,
          borderRadius: borderRadius,
        ),
        padding: padding,
        margin: margin,
        child: Text(
          message ?? '',
          style: textStyle ?? const TextStyle(color: Colors.white),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: duration ?? 2),
    );
    return;
  },
  'Action.openDialog': ({required action, required context, enclosing}) async {
    final String? pageUId = action.data['pageUid'] ?? action.data['pageId'];

    if (pageUId == null) {
      throw ArgumentError('Null value', 'pageId');
    }

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
    final barrierDismissible =
        eval<bool>(action.data['barrierDismissible'], context: context);
    final barrierColor = eval<String>(action.data['barrierColor'],
        context: context, enclosing: enclosing);

    final widgetScope = DUIWidgetScope.maybeOf(context);

    final waitForResult =
        NumDecoder.toBool(action.data['waitForResult']) ?? false;

    Object? result;
    result = await openDialog(
      pageUid: pageUId,
      context: context,
      pageArgs: evaluatedArgs,
      iconDataProvider: widgetScope?.iconDataProvider,
      imageProviderFn: widgetScope?.imageProviderFn,
      textStyleBuilder: widgetScope?.textStyleBuilder,
      barrierDismissible: barrierDismissible,
      barrierColor: makeColor(barrierColor),
    );

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
  'Action.callRestApi': ({required action, required context, enclosing}) async {
    final dataSourceId = action.data['dataSourceId'];
    Map<String, dynamic>? apiDataSourceArgs = action.data['args'];
    final apiModel = (context.tryRead<DUIPageBloc>()?.config)
        ?.getApiDataSource(dataSourceId);

    final args = apiDataSourceArgs?.map((key, value) {
      final evalue = eval(value, context: context);
      final dvalue = apiModel?.variables?[key]?.defaultValue;
      return MapEntry(key, evalue ?? dvalue);
    });

    final result = await ApiHandler.instance
        .execute(apiModel: apiModel!, args: args)
        .then((resp) {
      final response = {
        'body': resp.data,
        'statusCode': resp.statusCode,
        'headers': resp.headers,
        'requestObj': requestObjToMap(resp.requestOptions),
        'error': null,
      };

      final successCondition = action.data['successCondition'] as String?;
      final evaluatedSuccessCond = successCondition.let((p0) => eval<bool>(
              successCondition,
              context: context,
              enclosing: ExprContext(
                  variables: {'response': response}, enclosing: enclosing))) ??
          successCondition == null || successCondition.isEmpty;

      if (evaluatedSuccessCond) {
        final successAction = ActionFlow.fromJson(action.data['onSuccess']);
        return ActionHandler.instance.execute(
            context: context,
            actionFlow: successAction,
            enclosing: ExprContext(
                variables: {'response': response}, enclosing: enclosing));
      } else {
        final errorAction = ActionFlow.fromJson(action.data['onError']);
        return ActionHandler.instance.execute(
            context: context,
            actionFlow: errorAction,
            enclosing: ExprContext(
                variables: {'response': response}, enclosing: enclosing));
      }
    }, onError: (e) async {
      final errorAction = ActionFlow.fromJson(action.data['onError']);

      final response = {
        'body': e.response.data,
        'statusCode': e.response.statusCode,
        'headers': e.response.headers,
        'requestObj': requestObjToMap(e.requestOptions),
        'error': e.message,
      };

      return ActionHandler.instance.execute(
          context: context,
          actionFlow: errorAction,
          enclosing: ExprContext(
              variables: {'response': response}, enclosing: enclosing));
    });

    return result;
  },
  'Action.handleDigiaMessage': (
      {required action, required context, enclosing}) {
    final name = action.data['name'];
    final body = action.data['body'];
    final payload = evalDynamic(body, context, enclosing);

    print('Message Handled: $name');
    print('Message Body: $payload');

    final handler = DUIWidgetScope.maybeOf(context)?.onMessageReceived;
    if (handler == null) return;

    handler(MessagePayload(
      context: context,
      name: name,
      body: payload,
      dispatchAction: (p0) async {
        final actionFlow =
            ActionFlow(actions: [ActionProp(type: p0.type, data: p0.data)]);
        return ActionHandler.instance.execute(
            context: context, actionFlow: actionFlow, enclosing: enclosing);
      },
    ));

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
  'Action.filePicker': ({required action, required context, enclosing}) async {
    final bloc = context.tryRead<DUIPageBloc>();
    if (bloc == null) {
      throw 'Action.filePicker called on a widget which is not wrapped in DUIPageBloc';
    }

    final fileType = eval<String>(action.data['fileType'],
        context: context, enclosing: enclosing);
    final sizeLimit = eval<double>(action.data['sizeLimit'],
        context: context, enclosing: enclosing);
    final showToast = NumDecoder.toBool(action.data['showToast']) ?? true;
    final isMultiSelect =
        NumDecoder.toBool(action.data['isMultiSelected']) ?? false;
    final selectedPageState = action.data['selectedPageState'];
    final rebuildPage = NumDecoder.toBool(action.data['rebuildPage']) ?? false;

    final type = toFileType(fileType);

    List<PlatformFile>? platformFiles;
    bool isSinglePick;
    try {
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: type,
        allowMultiple: isMultiSelect,
        allowedExtensions: type == FileType.custom ? ['pdf'] : null,
      );

      isSinglePick = pickedFile?.isSinglePick ?? true;

      if (pickedFile == null) {
        // User canceled the picker
        return;
      }

      final toast = FToast().init(context);

      if (sizeLimit != null && showToast) {
        platformFiles = pickedFile.files.where((file) {
          if (file.size > sizeLimit * 1024) {
            toast.showToast(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.black,
                ),
                child: Text(
                  'File ${file.name} of size ${(file.size / 1000).toStringAsFixed(2)}kB selected exceeds the size limit of ${sizeLimit}kB.',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              gravity: ToastGravity.BOTTOM,
              toastDuration: const Duration(seconds: 2),
            );
            return false;
          }
          return true;
        }).toList();
      } else {
        platformFiles = pickedFile.files;
      }
    } catch (e) {
      print('Error picking file: $e');
      return;
    }

    if (platformFiles.isNotEmpty) {
      try {
        List<DUIFile> finalFiles =
            await Future.wait(platformFiles.map((platformFile) async {
          return DUIFile.fromPlatformFile(platformFile);
        }).toList());

        final variables = bloc.state.props.variables;
        final events = [
          {
            'variableName': selectedPageState,
            'value': isSinglePick ? finalFiles.first : finalFiles,
          }
        ];

        bloc.add(SetStateEvent(
          events: events
              .where((e) => variables?[e['variableName']] != null)
              .map((e) => SingleSetStateEvent(
                    variableName: e['variableName'],
                    context: context,
                    value: e['value'],
                  ))
              .toList(),
          rebuildPage: rebuildPage,
        ));
      } catch (e) {
        print('Error: $e');
      }
    }

    return;
  },
  'Action.upload': ({required action, required context, enclosing}) async {
    final dataSourceId = action.data['dataSourceId'];
    Map<String, dynamic>? apiDataSourceArgs = action.data['args'];
    final apiModel = (context.tryRead<DUIPageBloc>()?.config)
        ?.getApiDataSource(dataSourceId);

    final args = apiDataSourceArgs?.map((key, value) {
      final evalue = eval(value, context: context);
      final dvalue = apiModel?.variables?[key]?.defaultValue;
      return MapEntry(key, evalue ?? dvalue);
    });

    final result = await ApiHandler.instance
        .execute(apiModel: apiModel!, args: args)
        .then((resp) {
      final response = {
        'body': resp.data,
        'statusCode': resp.statusCode,
        'headers': resp.headers,
        'requestObj': requestObjToMap(resp.requestOptions),
        'error': null,
      };

      final successCondition = action.data['successCondition'] as String?;
      final evaluatedSuccessCond = successCondition.let((p0) => eval<bool>(
              successCondition,
              context: context,
              enclosing: ExprContext(
                  variables: {'response': response}, enclosing: enclosing))) ??
          successCondition == null || successCondition.isEmpty;

      if (evaluatedSuccessCond) {
        final successAction = ActionFlow.fromJson(action.data['onSuccess']);
        return ActionHandler.instance.execute(
            context: context,
            actionFlow: successAction,
            enclosing: ExprContext(
                variables: {'response': response}, enclosing: enclosing));
      } else {
        final errorAction = ActionFlow.fromJson(action.data['onError']);
        return ActionHandler.instance.execute(
            context: context,
            actionFlow: errorAction,
            enclosing: ExprContext(
                variables: {'response': response}, enclosing: enclosing));
      }
    }, onError: (e) async {
      final errorAction = ActionFlow.fromJson(action.data['onError']);

      final response = {
        'body': e.response.data,
        'statusCode': e.response.statusCode,
        'headers': e.response.headers,
        'requestObj': requestObjToMap(e.requestOptions),
        'error': e.message,
      };

      return ActionHandler.instance.execute(
          context: context,
          actionFlow: errorAction,
          enclosing: ExprContext(
              variables: {'response': response}, enclosing: enclosing));
    });

    return result;
  },
  'Action.share': ({required action, required context, enclosing}) {
    final message = eval<String>(action.data['message'],
        context: context, enclosing: enclosing);
    final subject = eval<String>(action.data['subject'],
        context: context, enclosing: enclosing);

    if (message != null && message.isNotEmpty) {
      if (kIsWeb) {
        showDialog(
          context: context,
          useRootNavigator: false,
          builder: (cntxt) {
            return AlertDialog(
              title: const Text('Notice'),
              content: Text(
                  'This feature works only in mobile devices.\n\nMessage: "$message" '),
              actions: [
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        Share.share(message, subject: subject);
      }
      return;
    } else {
      return null;
    }
  },
  'Action.copyToClipBoard': (
      {required action, required context, enclosing}) async {
    final message = eval<String>(action.data['message'],
        context: context, enclosing: enclosing);

    final toast = FToast().init(context);

    if (message != null && message.isNotEmpty) {
      try {
        await Clipboard.setData(ClipboardData(text: message));
        toast.showToast(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.black,
            ),
            child: const Text(
              'Copied to Clipboard!',
              style: TextStyle(color: Colors.white),
            ),
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      } catch (e) {
        toast.showToast(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.black,
            ),
            child: const Text(
              'Failed to copy to clipboard.',
              style: TextStyle(color: Colors.white),
            ),
          ),
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 2),
        );
      }
      return;
    } else {
      return null;
    }
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

const Map<String, String> defaultHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

abstract class NavigatorHelper {
  static Future<T?> push<T extends Object?>(BuildContext context,
      GlobalKey<NavigatorState>? navigatorKey, Route<T> newRoute,
      {RoutePredicate? removeRoutesUntilPredicate}) {
    if (removeRoutesUntilPredicate == null) {
      final push =
          navigatorKey?.currentState?.push ?? Navigator.of(context).push;
      return push(newRoute);
    }

    final pushAndRemoveUntil = navigatorKey?.currentState?.pushAndRemoveUntil ??
        Navigator.of(context).pushAndRemoveUntil;
    return pushAndRemoveUntil(newRoute, removeRoutesUntilPredicate);
  }
}

requestObjToMap(dynamic request) {
  return {
    'url': request.path,
    'method': request.method,
    'headers': request.headers,
    'data': request.data,
    'queryParameters': request.queryParameters,
  };
}

toFileType(String? fileType) {
  switch (fileType!.toLowerCase()) {
    case 'image':
      return FileType.image;
    case 'video':
      return FileType.video;
    case 'audio':
      return FileType.audio;
    case 'pdf':
      return FileType.custom;
    default:
      return FileType.any;
  }
}
