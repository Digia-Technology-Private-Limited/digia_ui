import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;

import '../config/model.dart';
import '../config/resolver.dart';
import '../network/netwok_config.dart';
import '../network/network_client.dart';
import '../preferences_store.dart';
import '../version.dart';
import 'config.dart';

class DigiaUI {
  final InitConfig initConfig;
  final NetworkClient networkClient;
  final DUIConfig dslConfig;

  DigiaUI._(
    this.initConfig,
    this.networkClient,
    this.dslConfig,
  );

  void setEnvVariable(String varName, Object? value) {
    dslConfig.setEnvVariable(varName, value);
  }

  // Main initialization method (eager pattern)
  static Future<DigiaUI> createWith(InitConfig options) async {
    // Initialize Preferences
    await PreferencesStore.instance.initialize();

    final headers = await _createDigiaHeaders(options, "");

    final networkClient = NetworkClient(
      options.developerConfig.baseUrl,
      headers,
      options.networkConfiguration ?? NetworkConfiguration.withDefaults(),
      options.developerConfig,
    );

    final config =
        await ConfigResolver(options.flavor, networkClient).getConfig();
    // Initialize App State

    if (options.developerConfig.inspector?.stateObserver != null) {
      // TODO: R1.0
      // StateContext.observer = options.developerConfig.inspector?.stateObserver;
    }

    return DigiaUI._(options, networkClient, config);
  }

  static Future<Map<String, dynamic>> _createDigiaHeaders(
    InitConfig options,
    String? uuid,
  ) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var packageName = packageInfo.packageName;
    var appVersion = packageInfo.version;
    var appbuildNumber = packageInfo.buildNumber;

    return NetworkClient.getDefaultDigiaHeaders(
      packageVersion,
      options.accessKey,
      _getPlatform(),
      uuid,
      packageName,
      appVersion,
      appbuildNumber,
      options.flavor.environment.name,
    );
  }

  static String _getPlatform() {
    if (kIsWeb) return 'mobile_web';

    if (Platform.isIOS) return 'ios';

    if (Platform.isAndroid) return 'android';

    return 'mobile_web';
  }
}
