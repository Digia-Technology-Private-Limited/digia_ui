import '../jsFunctions/js_functions.dart';

class WebJsFunctions implements JSFunctions {
  @override
  callJs(String fnName, dynamic v1) {
    // TODO: implement additionFn
    throw UnimplementedError();
  }
}

JSFunctions getJSFunction() => WebJsFunctions();
