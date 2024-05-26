import 'dart:convert';
import 'dart:io';

import 'package:flutter_js/flutter_js.dart';
import '../functions/download.dart';
import './js_functions.dart';

class MobileJsFunctions implements JSFunctions {
  JavascriptRuntime runtime = getJavascriptRuntime();
  Stopwatch stopwatch = Stopwatch();
  late String jsFile;
  MobileJsFunctions() {
    initJs();
  }

  void initJs() async {
    final file = File(await localPath + "/functions.js");
    jsFile = file.readAsStringSync(encoding: utf8);
    // jsFile = await path;
  }

  @override
  dynamic callJs(String fnName, dynamic v1) async {
    stopwatch.start();
    JsEvalResult jsEvalResult = runtime.evaluate('$jsFile$fnName($v1)');

    // int result = int.parse(jsEvalResult.stringResult);
    print('Result() executed in ${json.encode(jsEvalResult.rawResult)}');
    stopwatch.stop();
    stopwatch.reset();
    return 1;
  }
}

JSFunctions getJSFunction() => MobileJsFunctions();
