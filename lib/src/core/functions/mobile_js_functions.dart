import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

import '../../../digia_ui.dart';
import '../../Utils/download_operations.dart';
import '../../Utils/file_operations.dart';
import '../../utils/logger.dart';
import './js_functions.dart';

class MobileJsFunctions implements JSFunctions {
  final FileOperations fileOps = const FileOperationsImpl();
  final FileDownloader downloadOps = FileDownloaderImpl();

  JavascriptRuntime runtime = getJavascriptRuntime();
  late String jsFile;

  @override
  Future<bool> initFunctions(FunctionInitStrategy strategy) async {
    try {
      switch (strategy) {
        case PreferRemote(
            remotePath: String remotePath,
            version: int? version,
          ):
          String fileName = JSFunctions.getFunctionsFileName(version);
          final fileExists =
              version == null ? false : await fileOps.exists(fileName);
          if (!fileExists) {
            var res = await downloadOps.downloadFile(remotePath, fileName);
            if (res == null) return false;
          }
          final file = await fileOps.readString(fileName);
          if (file == null) return false;
          jsFile = file;
          runtime.evaluate(jsFile);
          return true;
        case PreferLocal(localPath: String localPath):
          jsFile = await rootBundle.loadString(localPath);
          runtime.evaluate(jsFile);
          return true;
      }
    } catch (e) {
      Logger.error('file not found', tag: 'MobileJsFunctions', error: e);
      return false;
    }
  }

  @override
  dynamic callJs(String fnName, dynamic v1) {
    var input = json.encode(v1);
    JsEvalResult jsEvalResult =
        runtime.evaluate('JSON.stringify($fnName($input))');
    if (jsEvalResult.isError) {
      if (DigiaUIManager().host is DashboardHost || kDebugMode) {
        Logger.error('--------------ERROR Running Function-----------',
            tag: 'MobileJsFunctions');
        Logger.log('functionName ---->    $fnName', tag: 'MobileJsFunctions');
        Logger.log('input ----------> $input', tag: 'MobileJsFunctions');
        Logger.error('error -------> ${jsEvalResult.stringResult}',
            tag: 'MobileJsFunctions');
      }
      throw Exception(
          'Error running function $fnName \n ${jsEvalResult.stringResult}');
    }
    var finalRes = json.decode(jsEvalResult.stringResult);
    return finalRes;
  }

  @override
  Future<dynamic> callAsyncJs(String fnName, dynamic v1) async {
    var input = json.encode(v1);

    // Evaluate JS and get promise result
    JsEvalResult jsEvalResult = await runtime.evaluateAsync('$fnName($input)');

    // 🔹 Handle promise properly
    JsEvalResult promiseResult = await runtime.handlePromise(jsEvalResult);

    if (promiseResult.isError) {
      if (DigiaUIManager().host is DashboardHost || kDebugMode) {
        Logger.error('--------------ERROR Running Function-----------',
            tag: 'MobileJsFunctions');
        Logger.log('functionName ---->    $fnName', tag: 'MobileJsFunctions');
        Logger.log('input ----------> $input', tag: 'MobileJsFunctions');
        Logger.error('error -------> ${promiseResult.stringResult}',
            tag: 'MobileJsFunctions');
      }
      throw Exception(
          'Error running function $fnName \n ${promiseResult.stringResult}');
    }

    var finalRes = json.decode(promiseResult.stringResult);
    return finalRes;
  }
}

JSFunctions getJSFunction() => MobileJsFunctions();
