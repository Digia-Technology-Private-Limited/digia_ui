import '../dui_dev_config.dart';
import '../network/netwok_config.dart';
import 'flavor.dart';

class InitConfig {
  final String accessKey;
  final Flavor flavor;
  final NetworkConfiguration? networkConfiguration;
  final DeveloperConfig developerConfig;

  InitConfig({
    required this.accessKey,
    required this.flavor,
    this.networkConfiguration,
  }) : developerConfig = DeveloperConfig();

  // Private constructor
  InitConfig._({
    required this.accessKey,
    required this.flavor,
    this.networkConfiguration,
    DeveloperConfig? developerConfig,
  }) : developerConfig = developerConfig ?? DeveloperConfig();

  static InitConfig internal({
    required String accessKey,
    required Flavor flavor,
    NetworkConfiguration? networkConfiguration,
    required DeveloperConfig developerConfig,
  }) {
    return InitConfig._(
      accessKey: accessKey,
      flavor: flavor,
      networkConfiguration: networkConfiguration,
      developerConfig: developerConfig,
    );
  }
}
