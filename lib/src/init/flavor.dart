import 'environment.dart';

enum FlavorOption { debug, staging, release, version }

sealed class Flavor {
  final FlavorOption value;
  final Environment environment;
  Flavor(
    this.value, {
    this.environment = Environment.production,
  });

  factory Flavor.debug({
    String? branchName,
    Environment environment,
  }) = DebugFlavor;

  factory Flavor.staging({
    Environment environment,
  }) = StagingFlavor;

  factory Flavor.versioned({
    required int version,
    Environment environment,
  }) = VersionedFlavor;

  factory Flavor.release({
    required DSLInitStrategy initStrategy,
    required String appConfigPath,
    required String functionsPath,
  }) = ReleaseFlavor;
}

class DebugFlavor extends Flavor {
  final String? branchName;

  DebugFlavor({
    this.branchName,
    super.environment,
  }) : super(FlavorOption.debug);
}

class StagingFlavor extends Flavor {
  StagingFlavor({
    super.environment,
  }) : super(FlavorOption.staging);
}

class VersionedFlavor extends Flavor {
  final int version;

  VersionedFlavor({
    required this.version,
    super.environment,
  }) : super(FlavorOption.version);
}

class ReleaseFlavor extends Flavor {
  final DSLInitStrategy initStrategy;
  final String appConfigPath;
  final String functionsPath;

  ReleaseFlavor({
    required this.initStrategy,
    required this.appConfigPath,
    required this.functionsPath,
  }) : super(FlavorOption.release);
}

sealed class DSLInitStrategy {}

class NetworkFirstStrategy extends DSLInitStrategy {
  final Duration timeout;
  NetworkFirstStrategy(int timeoutInSeconds)
      : timeout = Duration(seconds: timeoutInSeconds);
}

class CacheFirstStrategy extends DSLInitStrategy {}

class LocalFirstStrategy extends DSLInitStrategy {}
