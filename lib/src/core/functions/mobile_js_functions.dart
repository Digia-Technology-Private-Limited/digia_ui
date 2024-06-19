import 'dart:convert';

import 'package:flutter_js/flutter_js.dart';
import '../../Utils/file_operations.dart';
import '../functions/download.dart';
import './js_functions.dart';

class MobileJsFunctions implements JSFunctions {
  JavascriptRuntime runtime = getJavascriptRuntime();
  late String jsFile;

  @override
  Future fetchJsFile(String path) async {
    try {
      await downloadFunctionsFile(path);
      jsFile = await readFileString('functions.js') ?? '';
    } catch (e) {
      print('file not found');
    }
  }

  @override
  dynamic callJs(String fnName, dynamic v1) {
    JsEvalResult jsEvalResult =
        runtime.evaluate('$jsFile;JSON.stringify($fnName($v1))');
    print('Result() executed in ${jsEvalResult.stringResult}');
    var finalRes = json.decode(jsEvalResult.stringResult);
    return finalRes;
  }
}

JSFunctions getJSFunction() => MobileJsFunctions();
