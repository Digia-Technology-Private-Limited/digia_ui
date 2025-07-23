import 'dart:io';

import 'package:derry/version.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../digia_ui.dart';
import 'config/model.dart';
import 'config/resolver.dart';
import 'network/network_client.dart';

class Environment {
  final String name;

  const Environment._(this.name);

  Environment.custom(this.name);

  static const local = Environment._('local');
  static const development = Environment._('development');
  static const production = Environment._('production');

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Environment &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

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
    required InitStrategy initStrategy,
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
  final InitStrategy initStrategy;
  final String appConfigPath;
  final String functionsPath;

  ReleaseFlavor({
    required this.initStrategy,
    required this.appConfigPath,
    required this.functionsPath,
  }) : super(FlavorOption.release);
}

sealed class InitStrategy {}

class NetworkFirstStrategy extends InitStrategy {
  final Duration timeout;
  NetworkFirstStrategy({this.timeout = const Duration(seconds: 30)});
}

class CacheFirstStrategy extends InitStrategy {}

class LocalFirstStrategy extends InitStrategy {}

class InitOptions {
  final String accessKey;
  final Flavor flavor;
  final NetworkConfiguration? networkConfiguration;
  final DeveloperConfig _developerConfig;

  InitOptions({
    required this.accessKey,
    required this.flavor,
    this.networkConfiguration,
  }) : _developerConfig = DeveloperConfig();

  // Private constructor
  InitOptions._({
    required this.accessKey,
    required this.flavor,
    this.networkConfiguration,
    DeveloperConfig? developerConfig,
  }) : _developerConfig = developerConfig ?? DeveloperConfig();

  static InitOptions internal({
    required String accessKey,
    required Flavor flavor,
    NetworkConfiguration? networkConfiguration,
    required DeveloperConfig developerConfig,
  }) {
    return InitOptions._(
      accessKey: accessKey,
      flavor: flavor,
      networkConfiguration: networkConfiguration,
      developerConfig: developerConfig,
    );
  }
}

// class SDKHostContext {
//   final bool logJsErrors;
//   final bool showCopyToClipboardToast;
//   final bool reportWidgetCrashes;
//   final bool useProxyUrl;
//   final bool useResourceProxyUrl;
//   final String? proxyUrl;
//   final String? resourceProxyUrl;
// }

// class DigiaUIInternalUsageConfig {
//   //for android/ios
//   // final String? proxyUrl;
//   DUIInspector? inspector;
//   DUILogger? logger;
//   final SDKHostContext? hostContext;
// }

class DigiaUI {
  final InitOptions _initOptions;
  final NetworkClient networkClient;
  final DUIConfig config;
  // Analytics??

  DigiaUI._(
    this._initOptions,
    this.networkClient,
    this.config,
  );

  // Main initialization method (eager pattern)
  static Future<DigiaUI> createWith(InitOptions options) async {
    // Initialize Preferences
    await PreferencesStore.initialize();

    final headers = await _createDigiaHeaders(options, "");

    final networkClient = NetworkClient(
      options._developerConfig.baseUrl,
      headers,
      options.networkConfiguration ?? NetworkConfiguration.withDefaults(),
      options._developerConfig,
    );

    final config = await ConfigResolver(options.flavor).getConfig();

    // Initialize App State

    if (options._developerConfig.inspector?.stateObserver != null) {
      // StateContext.observer = developerConfig?.inspector?.stateObserver;
    }

    return DigiaUI._(options, networkClient, config);
  }

  static Future<Map<String, dynamic>> _createDigiaHeaders(
    InitOptions options,
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

class DigiaUIApp extends StatefulWidget {
  final DigiaUI digiaUI;
  final Widget child;
  final DUIAnalytics? analytics;

  const DigiaUIApp({
    super.key,
    required this.digiaUI,
    required this.child,
    this.analytics,
  });

  @override
  State<DigiaUIApp> createState() => _DigiaUIAppState();
}

class _DigiaUIAppState extends State<DigiaUIApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DigiaUIScope(child: widget.child);
  }
}

enum DigiaUIState { loading, ready, error }

class DigiaUIStatus {
  final DigiaUIState state;
  final DigiaUI? digiaUI;
  final Object? error;
  final StackTrace? stackTrace;

  const DigiaUIStatus._({
    required this.state,
    this.digiaUI,
    this.error,
    this.stackTrace,
  });

  const DigiaUIStatus.loading() : this._(state: DigiaUIState.loading);

  const DigiaUIStatus.ready(DigiaUI digiaUI)
      : this._(state: DigiaUIState.ready, digiaUI: digiaUI);

  const DigiaUIStatus.error(Object error, [StackTrace? stackTrace])
      : this._(state: DigiaUIState.error, error: error, stackTrace: stackTrace);

  bool get isLoading => state == DigiaUIState.loading;
  bool get isReady => state == DigiaUIState.ready;
  bool get hasError => state == DigiaUIState.error;
}

class DigiaUIAppBuilder extends StatefulWidget {
  final InitOptions options;
  final Widget Function(BuildContext context, DigiaUIStatus status) builder;

  const DigiaUIAppBuilder({
    super.key,
    required this.options,
    required this.builder,
  });

  @override
  State<DigiaUIAppBuilder> createState() => _DigiaUIAppBuilderState();
}

class _DigiaUIAppBuilderState extends State<DigiaUIAppBuilder> {
  DigiaUIStatus _status = const DigiaUIStatus.loading();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    try {
      final digiaUI = await DigiaUI.createWith(widget.options);
      if (mounted) {
        setState(() {
          _status = DigiaUIStatus.ready(digiaUI);
        });
      }
    } catch (error, stackTrace) {
      if (mounted) {
        setState(() {
          _status = DigiaUIStatus.error(error, stackTrace);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.builder(context, _status);

    if (!_status.isReady) return child;

    return DigiaUIApp(digiaUI: _status.digiaUI!, child: child);
  }
}
