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
    final appConfig =
        DUIConfig(await provider.getAppConfigFromNetwork(networkPath));
    await provider.initFunctions(remotePath: appConfig.functionsFilePath);
    return appConfig;
  }
}
