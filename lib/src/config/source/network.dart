import '../exception.dart';
import '../model.dart';
import '../provider.dart';
import 'base.dart';

class NetworkConfigSource implements ConfigSource {
  final String networkPath;
  final ConfigProvider provider;
  final Duration? timeout;

  NetworkConfigSource(
    this.provider,
    this.networkPath, {
    this.timeout,
  });

  @override
  Future<DUIConfig> getConfig() async {
    try {
      final networkData = await provider.getAppConfigFromNetwork(networkPath);
      if (networkData == null || networkData.isEmpty) {
        throw ConfigException(
          'Network response is null',
          type: ConfigErrorType.network,
        );
      }
      DUIConfig appConfig;
      try {
        appConfig = DUIConfig(networkData);
      } catch (e, stackTrace) {
        throw ConfigException(
          'Failed to parse network config data',
          type: ConfigErrorType.invalidData,
          originalError: e,
          stackTrace: stackTrace,
        );
      }
      await provider.initFunctions(remotePath: appConfig.functionsFilePath);
      return appConfig;
    } catch (e, stackTrace) {
      throw ConfigException(
        'Failed to load config from network',
        type: ConfigErrorType.network,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
