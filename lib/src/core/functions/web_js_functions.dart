import 'dart:async';
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
  Future<bool> initFunctions(FunctionInitStrategy strategy) async {
    switch (strategy) {
      case PreferRemote(remotePath: String remotePath):
        // We need a Completer to ensure that we wait till the source is set
        // This fixes bug where fnNames are not found on first load
        Completer completer = Completer();
        ScriptElement script = ScriptElement()
          ..onLoad.listen((_) => completer.complete(true))
          ..src = '$remotePath?t=${DateTime.now().millisecondsSinceEpoch}'
          ..type = 'text/javascript';
        document.head?.append(script);
        return await completer.future;
      case PreferLocal():
        throw Exception('Local strategy not available for web');
    }
  }
}

JSFunctions getJSFunction() => WebJsFunctions();
