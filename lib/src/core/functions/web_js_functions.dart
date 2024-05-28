import 'dart:html';
import 'dart:js' as js;
import '../functions/js_functions.dart';

class WebJsFunctions implements JSFunctions {
  @override
  callJs(String fnName, dynamic v1) {
    var obj = js.JsObject.jsify(v1);
    return js.context.callMethod(fnName, [obj]);
  }

  @override
  fetchJsFile(String path) {
    ScriptElement script = ScriptElement()
      ..src = path
      ..type = 'text/javascript';
    document.head?.append(script);
  }
}

JSFunctions getJSFunction() => WebJsFunctions();
