import 'dart:async';

import 'package:flutter/foundation.dart';

import '../init/flavor.dart';
import 'model.dart';
import 'provider.dart';
import 'source/asset.dart';
import 'source/base.dart';
import 'source/cache.dart';
import 'source/delegated.dart';
import 'source/network.dart';
import 'source/network_file.dart';

class ConfigStrategyFactory {
  static ConfigSource createStrategy(
    Flavor flavor,
    ConfigProvider provider,
  ) {
    return switch (flavor) {
      DebugFlavor() => _createDebugConfigSource(provider, flavor.branchName),
      StagingFlavor() =>
        NetworkConfigSource(provider, '/config/getAppConfigStaging'),
      VersionedFlavor() => _createVersionedSource(provider, flavor.version),
      ReleaseFlavor() when kIsWeb =>
        NetworkFileConfigSource(provider, '/config/getAppConfigRelease'),
      ReleaseFlavor() => _createReleaseFlavorConfigSource(
          provider,
          flavor.initStrategy,
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

ConfigSource _createDebugConfigSource(
    ConfigProvider provider, String? branchName) {
  provider.addBranchName(branchName);
  return NetworkConfigSource(provider, '/config/getAppConfig');
}

ConfigSource _createReleaseFlavorConfigSource(
  ConfigProvider provider,
  DSLInitStrategy priority,
  String appConfigPath,
  String functionsPath,
) {
  return switch (priority) {
    NetworkFirstStrategy(timeout: var timeout) =>
      DelegatedConfigSource(() async {
        final burnedSource =
            AssetConfigSource(provider, appConfigPath, functionsPath);
        final burnedConfig = await burnedSource.getConfig();
        DUIConfig config = burnedConfig;

        try {
          final cachedSource = CachedConfigSource(provider, 'appConfig.json');
          final cachedConfig = await cachedSource.getConfig();

          if (cachedConfig.version! >= burnedConfig.version!) {
            config = cachedConfig;
          } else {
            await provider.fileOps.delete('appConfig.json');
          }
        } catch (_) {}

        if (config.version != null) {
          provider.addVersionHeader(config.version!);
        }

        try {
          final networkFileSource = NetworkFileConfigSource(
            provider,
            '/config/getAppConfigRelease',
            timeout: timeout,
          );
          config = await networkFileSource.getConfig();
        } catch (_) {}

        return config;
      }),
    CacheFirstStrategy() => DelegatedConfigSource(() async {
        final burnedSource =
            AssetConfigSource(provider, appConfigPath, functionsPath);
        final burnedConfig = await burnedSource.getConfig();
        DUIConfig configToUse = burnedConfig;

        try {
          final cachedSource = CachedConfigSource(provider, 'appConfig.json');
          final cachedConfig = await cachedSource.getConfig();

          if (cachedConfig.version! >= burnedConfig.version!) {
            configToUse = cachedConfig;
          } else {
            await provider.fileOps.delete('appConfig.json');
          }
        } catch (_) {}

        unawaited(NetworkFileConfigSource(
          provider,
          '/config/getAppConfigRelease',
        ).getConfig());

        return configToUse;
      }),
    LocalFirstStrategy() =>
      AssetConfigSource(provider, appConfigPath, functionsPath),
  };
}
