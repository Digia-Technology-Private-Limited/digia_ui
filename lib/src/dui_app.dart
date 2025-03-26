// import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';

import 'analytics/dui_analytics.dart';
import 'digia_ui_client.dart';
import 'dui_dev_config.dart';
import 'environment.dart';
import 'framework/font_factory.dart';
import 'framework/ui_factory.dart';
import 'network/netwok_config.dart';

class DUIApp extends StatelessWidget {
  final String digiaAccessKey;
  final GlobalKey<NavigatorState>? navigatorKey;
  final ThemeData? theme;
  final String baseUrl;
  final FlavorInfo flavorInfo;
  final String environment;
  final Object? data;
  final NetworkConfiguration networkConfiguration;
  final DeveloperConfig? developerConfig;
  final DUIAnalytics? analytics;
  final DUIFontFactory? fontFactory;

  // final Map<String, dynamic> initProperties;

  const DUIApp({
    super.key,
    required this.digiaAccessKey,
    this.navigatorKey,
    required this.flavorInfo,
    required this.environment,
    this.theme,
    required this.baseUrl,
    required this.networkConfiguration,
    this.developerConfig,
    this.analytics,
    this.fontFactory,
    this.data,
  });

  Future<void> _makeFuture() async {
    if (data != null) {
      return DigiaUIClient.initializeFromData(
          accessKey: digiaAccessKey,
          data: data,
          baseUrl: baseUrl,
          networkConfiguration: networkConfiguration,
          developerConfig: developerConfig);
    }

    return DigiaUIClient.init(
        accessKey: digiaAccessKey,
        flavorInfo: flavorInfo,
        environment: environment,
        baseUrl: baseUrl,
        networkConfiguration: networkConfiguration,
        developerConfig: developerConfig,
        duiAnalytics: analytics);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // key: key,
      debugShowCheckedModeBanner: false,
      // navigatorObservers: [ChuckerFlutter.navigatorObserver],
      theme: theme ??
          ThemeData(
            scaffoldBackgroundColor: Colors.white,
            brightness: Brightness.light,
          ),
      title: 'Digia App',
      home: FutureBuilder(
        future: _makeFuture(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Intializing from Cloud...'),
                      LinearProgressIndicator()
                    ],
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Could not fetch Config. ${snapshot.error?.toString()}',
                        style: const TextStyle(color: Colors.red, fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          DUIFactory().initialize(fontFactory: fontFactory);
          return DUIFactory().createInitialPage();
        },
      ),
    );
  }
}
