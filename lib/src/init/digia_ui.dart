import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;

import '../config/model.dart';
import '../config/resolver.dart';
import '../network/netwok_config.dart';
import '../network/network_client.dart';
import '../preferences_store.dart';
import '../version.dart';
import 'options.dart';

/// Core DigiaUI class responsible for initializing and managing the SDK.
///
/// This class handles the initialization of the Digia UI SDK, including network
/// configuration, preferences setup, and configuration loading. It serves as
/// the main entry point for SDK setup and provides methods for runtime
/// configuration management.
class DigiaUI {
  /// The initialization configuration provided during SDK setup.
  final DigiaUIOptions initConfig;

  /// The network client used for API communications.
  final NetworkClient networkClient;

  /// The DSL configuration containing widget definitions and app structure.
  final DUIConfig dslConfig;

  /// Creates a new DigiaUI instance with the specified configurations.
  ///
  /// This is a private constructor used internally after initialization.
  DigiaUI._(
    this.initConfig,
    this.networkClient,
    this.dslConfig,
  );

  /// Initializes the Digia UI SDK with the provided configuration.
  ///
  /// This is the main initialization method that sets up the SDK for use.
  /// It performs the following operations:
  /// - Initializes shared preferences store
  /// - Creates network client with proper headers
  /// - Loads configuration from the server
  /// - Sets up state observers if provided
  ///
  /// [options] contains all the configuration needed for initialization.
  ///
  /// Returns a fully initialized [DigiaUI] instance ready for use.
  ///
  /// Throws exceptions if initialization fails (network errors, invalid config, etc.).
  // Main initialization method (eager pattern)
  static Future<DigiaUI> initialize(DigiaUIOptions options) async {
    // Initialize Preferences
    await PreferencesStore.instance.initialize();

    final headers = await _createDigiaHeaders(options, '');

    final networkClient = NetworkClient(
      options.developerConfig.baseUrl,
      headers,
      options.networkConfiguration ?? NetworkConfiguration.withDefaults(),
      options.developerConfig,
    );

    final config =
        await ConfigResolver(options.flavor, networkClient).getConfig();

    if (options.developerConfig.inspector?.stateObserver != null) {
      // TODO: R1.0
      // StateContext.observer = options.developerConfig.inspector?.stateObserver;
    }

    return DigiaUI._(options, networkClient, config);
  }

  /// Creates the default headers required for Digia API communication.
  ///
  /// This method generates headers containing SDK version, platform information,
  /// app details, and authentication information.
  ///
  /// [options] contains the configuration including access key.
  /// [uuid] is an optional user identifier.
  ///
  /// Returns a map of headers to be used with network requests.
  static Future<Map<String, dynamic>> _createDigiaHeaders(
    DigiaUIOptions options,
    String? uuid,
  ) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var packageName = packageInfo.packageName;
    var appVersion = packageInfo.version;
    var appbuildNumber = packageInfo.buildNumber;
    // Android Only. Empty elsewhere.
    var appSignatureSha256 = packageInfo.buildSignature;

    return NetworkClient.getDefaultDigiaHeaders(
      packageVersion,
      options.accessKey,
      _getPlatform(),
      uuid,
      packageName,
      appVersion,
      appbuildNumber,
      options.flavor.environment.name,
      appSignatureSha256,
    );
  }

  /// Determines the current platform for API communication.
  ///
  /// Returns platform identifier string:
  /// - 'ios' for iOS devices
  /// - 'android' for Android devices
  /// - 'mobile_web' for web or other platforms
  static String _getPlatform() {
    if (kIsWeb) return 'mobile_web';

    if (Platform.isIOS) return 'ios';

    if (Platform.isAndroid) return 'android';

    return 'mobile_web';
  }
}
