import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import '../../../digia_ui.dart';
import '../../framework/utils/functional_util.dart';
import '../functions/js_functions.dart';

class WebJsFunctions implements JSFunctions {
  @override
  callJs(String fnName, dynamic v1) {
    var obj = js.JsObject.jsify(as<Object>(v1));
    try {
      var res = js.context.callMethod(fnName, [obj]);
      var finalRes = jsonDecode(
          as<String>(js.context['JSON'].callMethod('stringify', [res])));
      return finalRes;
    } catch (e) {
      if (DigiaUIManager().host is DashboardHost || kDebugMode) {
        print('--------------ERROR Running Function-----------');
        print('functionName ---->    $fnName');
        print('input ----------> $v1');
        print('error -------> $e');
      }
      throw Exception('Error running function $fnName \n $e');
    }
  }

  @override
  callAsyncJs(String fnName, dynamic v1) {
    var obj = js.JsObject.jsify(as<Object>(v1));
    try {
      var res = js.context.callMethod(fnName, [obj]);
      var finalRes = jsonDecode(
          as<String>(js.context['JSON'].callMethod('stringify', [res])));
      return finalRes;
    } catch (e) {
      if (DigiaUIClient.instance.developerConfig?.host is DashboardHost ||
          kDebugMode) {
        print('--------------ERROR Running Function-----------');
        print('functionName ---->    $fnName');
        print('input ----------> $v1');
        print('error -------> $e');
      }
      throw Exception('Error running function $fnName \n $e');
    }
  }

  @override
  Future<bool> initFunctions(FunctionInitStrategy strategy) async {
    switch (strategy) {
      case PreferRemote(remotePath: String remotePath):
        // We need a Completer to ensure that we wait till the source is set
        // This fixes bug where fnNames are not found on first load
        Completer completer = Completer();
        web.HTMLScriptElement script = web.HTMLScriptElement()
          ..onLoad.listen((_) => completer.complete(true))
          ..onError.listen((_) => completer.complete(false))
          ..src = '$remotePath?t=${DateTime.now().millisecondsSinceEpoch}'
          ..type = 'text/javascript';
        web.document.head?.append(script);
        return await completer.future;
      case PreferLocal():
        throw Exception('Local strategy not available for web');
    }
  }
}

JSFunctions getJSFunction() => WebJsFunctions();
