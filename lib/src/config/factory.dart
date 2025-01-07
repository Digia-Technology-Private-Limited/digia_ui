import 'package:flutter/foundation.dart';

import '../environment.dart';
import 'provider.dart';
import 'source/asset.dart';
import 'source/base.dart';
import 'source/cache.dart';
import 'source/delegated.dart';
import 'source/fallback.dart';
import 'source/network.dart';
import 'source/network_file.dart';

class ConfigStrategyFactory {
  static ConfigSource createStrategy(
    FlavorInfo flavor,
    ConfigProvider provider,
  ) {
    return switch (flavor) {
      Debug() => NetworkConfigSource(provider, '/config/getAppConfig'),
      Staging() => NetworkConfigSource(provider, '/config/getAppConfigStaging'),
      Versioned() => _createVersionedSource(provider, flavor.version),
      Release() when kIsWeb =>
        NetworkFileConfigSource(provider, '/config/getAppConfigRelease'),
      Release() => _createReleaseFlavorConfigSource(
          provider,
          flavor.initPriority,
          flavor.appConfigPath,
          flavor.functionsPath,
        )
    };
  }
}

ConfigSource _createVersionedSource(ConfigProvider provider, int version) {
  provider.addVersionHeader(version);
  return NetworkConfigSource(provider, '/config/getAppConfigForVersion');
}

ConfigSource _createReleaseFlavorConfigSource(
  ConfigProvider provider,
  InitPriority priority,
  String appConfigPath,
  String functionsPath,
) {
  return switch (priority) {
    PrioritizeNetwork(timeout: var timeout) => DelegatedConfigSource(() async {
        final source = FallbackConfigSource(
          primary: CachedConfigSource(provider, 'appConfig.json'),
          fallback: [
            AssetConfigSource(provider, appConfigPath, functionsPath),
          ],
        );
        var config = await source.getConfig();
        if (config.version != null) {
          provider.addVersionHeader(config.version!);
        }

        try {
          final networkFileSource = NetworkFileConfigSource(
            provider,
            '/config/getAppConfigRelease',
            timeout: Duration(seconds: timeout),
          );
          config = await networkFileSource.getConfig();
        } catch (_) {}

        return config;
      }),
    PrioritizeCache() => FallbackConfigSource(
        primary: CachedConfigSource(provider, 'appConfig.json'),
        fallback: [
          NetworkFileConfigSource(
            provider,
            '/config/getAppConfigRelease',
          ),
          AssetConfigSource(provider, appConfigPath, functionsPath),
        ],
      ),
    PrioritizeLocal() =>
      AssetConfigSource(provider, appConfigPath, functionsPath),
  };
}
