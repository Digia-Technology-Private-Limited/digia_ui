import 'package:digia_ui/src/analytics/mixpanel.dart';
import 'package:flutter/material.dart';

import 'package:digia_ui/src/core/page/dui_page.dart';
import 'package:digia_ui/src/digia_ui_client.dart';

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

          return DUIPage(pageUid: initialRouteData.uid);
        },
      ),
    );
  }
}
