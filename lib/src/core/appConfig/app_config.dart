import 'app_config_stub.dart'
    if (dart.library.io) 'mobile_app_config.dart'
    if (dart.library.html) 'web_app_config.dart';

abstract class AppConfig {
  factory AppConfig() => getAppConfig();
  Future<Map<String, dynamic>?> getAppConfigFromNetwork(String path);
  Future<Map<String, dynamic>?> getAppConfigFileFromNetwork(String path);
}
