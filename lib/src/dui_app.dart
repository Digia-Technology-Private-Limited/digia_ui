import 'package:flutter/material.dart';

import 'analytics/mixpanel.dart';
import 'core/app_state_provider.dart';
import 'core/page/dui_page.dart';
import 'digia_ui_client.dart';

class DUIApp extends StatelessWidget {
  final String digiaAccessKey;
  final GlobalKey<NavigatorState>? navigatorKey;
  final ThemeData? theme;
  final String? baseUrl;
  final String? mixpanelKey;
  // final Map<String, dynamic> initProperties;

  DUIApp({
    super.key,
    required this.digiaAccessKey,
    this.navigatorKey,
    this.theme,
    this.mixpanelKey,
    this.baseUrl,
    // required this.initProperties
  }) {
    if (mixpanelKey != null) {
      MixpanelManager.init(mixpanelKey!, digiaAccessKey);
    }
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
        future: DigiaUIClient.initializeFromNetwork(
            accessKey: digiaAccessKey, baseUrl: baseUrl),
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
