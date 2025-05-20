import 'dart:async';

import 'package:flutter/foundation.dart';

import '../environment.dart';
import 'model.dart';
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
      Debug() => _createDebugConfigSource(provider, flavor.branchName),
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

ConfigSource _createDebugConfigSource(
    ConfigProvider provider, String? branchName) {
  provider.addBranchName(branchName);
  return NetworkConfigSource(provider, '/config/getAppConfig');
}

ConfigSource _createReleaseFlavorConfigSource(
  ConfigProvider provider,
  InitPriority priority,
  String appConfigPath,
  String functionsPath,
) {
  return switch (priority) {
    PrioritizeNetwork(timeout: var timeout) => DelegatedConfigSource(() async {

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
            timeout: Duration(seconds: timeout),
          );
          config = await networkFileSource.getConfig();
        } catch (_) {}

        return config;
      }),
    PrioritizeCache() => DelegatedConfigSource(() async {
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
    PrioritizeLocal() =>
      AssetConfigSource(provider, appConfigPath, functionsPath),
  };
}
