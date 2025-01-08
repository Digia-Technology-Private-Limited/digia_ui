import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

import '../../Utils/download_operations.dart';
import '../../Utils/file_operations.dart';
import './js_functions.dart';

class MobileJsFunctions implements JSFunctions {
  final FileOperations fileOps = const FileOperationsImpl();
  final DownloadOperations downloadOps = DownloadOperationsImpl();

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
          return true;
        case PreferLocal(localPath: String localPath):
          jsFile = await rootBundle.loadString(localPath);
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
        runtime.evaluate('$jsFile;JSON.stringify($fnName($input))');
    print('Result() executed in ${jsEvalResult.stringResult}');
    var finalRes = json.decode(jsEvalResult.stringResult);
    return finalRes;
  }
}

JSFunctions getJSFunction() => MobileJsFunctions();
