import '../dui_dev_config.dart';
import '../network/netwok_config.dart';
import 'flavor.dart';

/// Configuration class for initializing the Digia UI SDK.
///
/// This class contains all the necessary configuration parameters required
/// to initialize the SDK, including authentication, environment settings,
/// and optional developer configurations.
class DigiaUIOptions {
  /// The access key for your Digia project (required for authentication).
  final String accessKey;

  /// The environment flavor (development, staging, production).
  final Flavor flavor;

  /// Optional network configuration for customizing API behavior.
  final NetworkConfiguration? networkConfiguration;

  /// Developer configuration for debugging and advanced features.
  final DeveloperConfig developerConfig;

  /// Creates a new DigiaUIOptions with the specified parameters.
  ///
  /// [accessKey] is required and should be obtained from your Digia project.
  /// [flavor] specifies the environment (dev, staging, production).
  /// [networkConfiguration] is optional for customizing network behavior.
  DigiaUIOptions({
    required this.accessKey,
    required this.flavor,
    this.networkConfiguration,
  }) : developerConfig = DeveloperConfig();

  // Private constructor
  DigiaUIOptions._({
    required this.accessKey,
    required this.flavor,
    this.networkConfiguration,
    DeveloperConfig? developerConfig,
  }) : developerConfig = developerConfig ?? DeveloperConfig();

  /// Creates an internal DigiaUIOptions with additional developer configuration.
  ///
  /// This constructor is used internally by the SDK and provides access
  /// to advanced developer features and debugging tools.
  ///
  /// [accessKey] is required for authentication.
  /// [flavor] specifies the environment.
  /// [networkConfiguration] is optional for network customization.
  /// [developerConfig] provides access to debugging and development features.
  static DigiaUIOptions internal({
    required String accessKey,
    required Flavor flavor,
    NetworkConfiguration? networkConfiguration,
    required DeveloperConfig developerConfig,
  }) {
    return DigiaUIOptions._(
      accessKey: accessKey,
      flavor: flavor,
      networkConfiguration: networkConfiguration,
      developerConfig: developerConfig,
    );
  }
}
