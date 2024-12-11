import 'config_stub.dart';

abstract class ConfigFile {
  factory ConfigFile() => getConfigFile();
  Future<bool> initAppConfig(AppConfigInitStrategy strategy);
  static String getConfigFileName(int? version) {
    return version == null ? 'config.js' : 'config_v$version.js';
  }
}

sealed class AppConfigInitStrategy {}

class PreferConfigRemote extends AppConfigInitStrategy {
  final String remotePath;
  final int? version;
  PreferConfigRemote(this.remotePath, this.version);
}

class PreferConfigLocal extends AppConfigInitStrategy {
  final String localPath;
  PreferConfigLocal(this.localPath);
}
