import 'js_functions_stub.dart'
    if (dart.library.io) 'mobile_js_functions.dart'
    if (dart.library.html) 'web_js_functions.dart';

abstract class JSFunctions {
  factory JSFunctions() => getJSFunction();
  dynamic callJs(String fnName, dynamic data);
}
