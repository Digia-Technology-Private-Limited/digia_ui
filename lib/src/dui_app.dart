import 'package:flutter/material.dart';

import 'core/app_state_provider.dart';
import 'core/page/dui_page.dart';
import 'digia_ui_client.dart';
import 'network/netwok_config.dart';

enum Environment { staging, production, version }

class DUIApp extends StatelessWidget {
  final String digiaAccessKey;
  final GlobalKey<NavigatorState>? navigatorKey;
  final ThemeData? theme;
  final String? baseUrl;
  final Environment environment;
  final int version;
  final Object? data;
  static String? uuid;
  final NetworkConfiguration networkConfiguration;

  // final Map<String, dynamic> initProperties;

  const DUIApp(
      {super.key,
      required this.digiaAccessKey,
      required this.environment,
      this.navigatorKey,
      this.theme,
      this.baseUrl,
      required this.version,
      required this.networkConfiguration,
      this.data});

  _makeFuture() async {
    if (data != null) {
      return DigiaUIClient.initializeFromData(
          accessKey: digiaAccessKey, data: data, networkConfiguration: networkConfiguration);
    }

    return DigiaUIClient.initializeFromNetwork(
        accessKey: digiaAccessKey,
        environment: environment,
        version: version,
        baseUrl: baseUrl,
        //drive this at a later stage from appConfig API
        networkConfiguration: networkConfiguration);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // key: key,
      debugShowCheckedModeBanner: false,
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
            return const Scaffold(
              body: SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Could not fetch Config.',
                        style: TextStyle(color: Colors.red, fontSize: 24),
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
