import 'environment.dart';

/// Enumeration of available flavor options for the SDK.
enum FlavorOption {
  /// Debug flavor for development with remote configuration.
  debug,

  /// Staging flavor for testing with staging environment.
  staging,

  /// Release flavor for production with local assets.
  release,

  /// Versioned flavor for loading specific configuration versions.
  version
}

/// Base class for defining application flavors/environments.
///
/// Flavors determine how the SDK loads configuration and which environment
/// it connects to. Different flavors provide different initialization strategies
/// suitable for development, testing, and production scenarios.
sealed class Flavor {
  /// The type of flavor being used.
  final FlavorOption value;

  /// The target environment for this flavor.
  final Environment environment;

  /// Creates a flavor with the specified value and environment.
  Flavor(
    this.value, {
    this.environment = Environment.production,
  });

  /// Creates a debug flavor for development with optional branch specification.
  ///
  /// Debug flavor loads configuration from the server in real-time, making it
  /// perfect for development where you want to see changes immediately.
  ///
  /// [branchName] optionally specifies a specific branch to load from.
  /// [environment] specifies the target environment.
  factory Flavor.debug({
    String? branchName,
    Environment environment,
  }) = DebugFlavor;

  /// Creates a staging flavor for testing environments.
  ///
  /// Staging flavor is useful for testing with production-like configuration
  /// while still having the ability to update remotely.
  ///
  /// [environment] specifies the target environment.
  factory Flavor.staging({
    Environment environment,
  }) = StagingFlavor;

  /// Creates a versioned flavor for loading specific configuration versions.
  ///
  /// Versioned flavor allows you to load a specific version of your app
  /// configuration, useful for A/B testing or rollback scenarios.
  ///
  /// [version] specifies the exact version number to load.
  /// [environment] specifies the target environment.
  factory Flavor.versioned({
    required int version,
    Environment environment,
  }) = VersionedFlavor;

  /// Creates a release flavor for production deployment with local assets.
  ///
  /// Release flavor loads configuration from local app assets rather than
  /// from the network, providing the best performance and reliability for
  /// production deployments.
  ///
  /// [initStrategy] determines how configuration is loaded and cached.
  /// [appConfigPath] path to the app configuration asset.
  /// [functionsPath] path to the functions configuration asset.
  factory Flavor.release({
    required DSLInitStrategy initStrategy,
    required String appConfigPath,
    required String functionsPath,
  }) = ReleaseFlavor;
}

/// Debug flavor implementation for development environments.
///
/// This flavor loads configuration from the server in real-time, allowing
/// for immediate testing of configuration changes during development.
class DebugFlavor extends Flavor {
  /// Optional branch name to load configuration from a specific branch.
  final String? branchName;

  /// Creates a debug flavor with optional branch specification.
  DebugFlavor({
    this.branchName,
    super.environment,
  }) : super(FlavorOption.debug);
}

/// Staging flavor implementation for testing environments.
///
/// This flavor is suitable for testing and QA environments where you want
/// production-like behavior but still need the ability to update configuration
/// remotely.
class StagingFlavor extends Flavor {
  /// Creates a staging flavor.
  StagingFlavor({
    super.environment,
  }) : super(FlavorOption.staging);
}

/// Versioned flavor implementation for loading specific configuration versions.
///
/// This flavor allows you to load a specific version of your app configuration,
/// which is useful for A/B testing, rollback scenarios, or maintaining
/// consistency across different app releases.
class VersionedFlavor extends Flavor {
  /// The specific version number to load.
  final int version;

  /// Creates a versioned flavor with the specified version.
  VersionedFlavor({
    required this.version,
    super.environment,
  }) : super(FlavorOption.version);
}

/// Release flavor implementation for production deployments.
///
/// This flavor loads configuration from local app assets rather than from
/// the network, providing optimal performance and reliability for production
/// environments.
class ReleaseFlavor extends Flavor {
  /// The strategy for initializing and caching configuration.
  final DSLInitStrategy initStrategy;

  /// Path to the app configuration asset file.
  final String appConfigPath;

  /// Path to the functions configuration asset file.
  final String functionsPath;

  /// Creates a release flavor with local asset configuration.
  ReleaseFlavor({
    required this.initStrategy,
    required this.appConfigPath,
    required this.functionsPath,
  }) : super(FlavorOption.release);
}

/// Base class for defining DSL initialization strategies.
///
/// Different strategies determine how configuration is loaded, cached,
/// and updated in production environments.
sealed class DSLInitStrategy {}

/// Network-first initialization strategy.
///
/// This strategy attempts to load configuration from the network first,
/// falling back to cached or local assets if the network request fails
/// or times out.
class NetworkFirstStrategy extends DSLInitStrategy {
  /// The timeout duration for network requests.
  final Duration timeout;

  /// Creates a network-first strategy with the specified timeout.
  NetworkFirstStrategy({required int timeoutInMilliseconds})
      : timeout = Duration(milliseconds: timeoutInMilliseconds);
}

/// Cache-first initialization strategy.
///
/// This strategy loads configuration from cache first, providing fast startup
/// times. Network updates happen in the background for future app launches.
class CacheFirstStrategy extends DSLInitStrategy {}

/// Local-first initialization strategy.
///
/// This strategy loads configuration exclusively from local assets,
/// providing the fastest and most reliable startup experience.
class LocalFirstStrategy extends DSLInitStrategy {}
