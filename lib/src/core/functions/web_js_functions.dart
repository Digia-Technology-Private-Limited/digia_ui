import 'dart:convert';

import 'dart:html';
import 'dart:js' as js;
import '../functions/js_functions.dart';

class WebJsFunctions implements JSFunctions {
  @override
  callJs(String fnName, dynamic v1) {
    var obj = js.JsObject.jsify(v1);
    var res = js.context.callMethod(fnName, [obj]);
    var finalRes = jsonDecode(
       js.context['JSON'].callMethod(
           'stringify',
           [res]
       )
    );
    return finalRes;
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
