import 'js_functions_stub.dart'
    if (dart.library.io) 'mobile_js_functions.dart'
    if (dart.library.html) 'web_js_functions.dart';

abstract class JSFunctions {
  factory JSFunctions() => getJSFunction();
  dynamic callJs(String fnName, dynamic data);
  Future<bool> initFunctions(FunctionInitStrategy strategy);
  static getFunctionsFileName(int? version) {
    return version == null ? 'functions.js' : 'functions_v$version.js';
  }
}

sealed class FunctionInitStrategy {}

class PreferRemote extends FunctionInitStrategy {
  final String remotePath;
  final int? version;
  PreferRemote(this.remotePath, this.version);
}

class PreferLocal extends FunctionInitStrategy {
  final String localPath;
  PreferLocal(this.localPath);
}
