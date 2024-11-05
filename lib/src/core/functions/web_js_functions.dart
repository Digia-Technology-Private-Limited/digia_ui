import 'dart:convert';

import 'dart:html';
import 'dart:js' as js;
import '../../framework/utils/functional_util.dart';
import '../functions/js_functions.dart';

class WebJsFunctions implements JSFunctions {
  @override
  callJs(String fnName, dynamic v1) {
    var obj = js.JsObject.jsify(as<Object>(v1));
    var res = js.context.callMethod(fnName, [obj]);
    var finalRes = jsonDecode(
        as<String>(js.context['JSON'].callMethod('stringify', [res])));
    return finalRes;
  }

  @override
  Future<bool> initFunctions(FunctionInitStrategy strategy) {
    switch (strategy) {
      case PreferRemote(remotePath: String remotePath):
        ScriptElement script = ScriptElement()
          ..src = '$remotePath?t=${DateTime.now().millisecondsSinceEpoch}'
          ..type = 'text/javascript';
        document.head?.append(script);
        return Future.value(true);
      case PreferLocal():
        throw Exception('Local strategy not available for web');
    }
  }
}

JSFunctions getJSFunction() => WebJsFunctions();
