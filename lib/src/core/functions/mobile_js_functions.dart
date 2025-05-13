import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

import '../../../digia_ui.dart';
import '../../Utils/download_operations.dart';
import '../../Utils/file_operations.dart';
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
          jsFile = await fileOps.readString(fileName) ?? '';
          runtime.evaluate(jsFile);
          return true;
        case PreferLocal(localPath: String localPath):
          jsFile = await rootBundle.loadString(localPath);
          runtime.evaluate(jsFile);
          return true;
      }
    } catch (e) {
      print('file not found');
      return false;
    }
  }

  @override
  dynamic callJs(String fnName, dynamic v1) {
    var input = json.encode(v1);
    JsEvalResult jsEvalResult =
        runtime.evaluate('JSON.stringify($fnName($input))');
    if (jsEvalResult.isError) {
      if (DigiaUIClient.instance.developerConfig?.host is DashboardHost ||
          kDebugMode) {
        print('--------------ERROR Running Function-----------');
        print('functionName ---->    $fnName');
        print('input ----------> $input');
        print('error -------> ${jsEvalResult.stringResult}');
      }
      throw Exception(
          'Error running function $fnName \n ${jsEvalResult.stringResult}');
    }
    var finalRes = json.decode(jsEvalResult.stringResult);
    return finalRes;
  }
}

JSFunctions getJSFunction() => MobileJsFunctions();
