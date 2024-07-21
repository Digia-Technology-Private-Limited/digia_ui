// import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';

import '../digia_ui.dart';
import 'core/app_state_provider.dart';
import 'environment.dart';

class DUIApp extends StatelessWidget {
  final String digiaAccessKey;
  final ScrollBehavior? scrollBehavior;
  final GlobalKey<NavigatorState>? navigatorKey;
  final ThemeData? theme;
  final String baseUrl;
  final EnvironmentInfo environmentInfo;
  final Object? data;
  final NetworkConfiguration networkConfiguration;
  final DeveloperConfig? developerConfig;
  final DUIAnalytics? analytics;

  // final Map<String, dynamic> initProperties;

  const DUIApp(
      {super.key,
      required this.digiaAccessKey,
<<<<<<< Updated upstream
      required this.environment,
      this.scrollBehavior,
      this.navigatorKey,
=======
      required this.environmentInfo,
      required this.navigatorKey,
>>>>>>> Stashed changes
      this.theme,
      required this.baseUrl,
      required this.networkConfiguration,
      this.developerConfig,
      this.analytics,
      this.data});

  _makeFuture() async {
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
        environmentInfo: environmentInfo,
        baseUrl: baseUrl,
        networkConfiguration: networkConfiguration,
        developerConfig: developerConfig,
        duiAnalytics: analytics);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: scrollBehavior,
      // key: key,
      debugShowCheckedModeBanner: false,
      // navigatorObservers: [ChuckerFlutter.navigatorObserver],
      theme: theme ??
          ThemeData(
            fontFamily: 'Poppins',
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

          final initialRouteData =
              DigiaUIClient.getConfigResolver().getfirstPageData();

          return AppStateProvider(
              state: DigiaUIClient.instance.appState.variables,
              child: DUIPage(pageUid: initialRouteData.uid));
        },
      ),
    );
  }
}
