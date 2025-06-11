import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// const String baseUrl = 'http://localhost:3000/api/v1';
const String baseUrl = 'https://dev.digia.tech/api/v1';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DUIApp(
      digiaAccessKey: "681b8775af81b5e02c8d9f0a",
      baseUrl: baseUrl,
      flavorInfo: Debug('main'),
      // environmentInfo: Versioned(19),
      // environmentInfo: Production(PrioritizeNetwork(5), 'assets/prodAppConfig.json','assets/functions.js'),
      // flavorInfo: Release(PrioritizeCache(),
      //     'assets/prodAppConfig.json', 'assets/functions.js'),
      environment: Environment.development.name,
      // environmentInfo: Production(PrioritizeLocal(), 'assets/prodAppConfig.json','assets/functions.js'),
      navigatorKey: null,
      // developerConfig:
      //     DeveloperConfig(enableChucker: false, proxyUrl: "192.168.119.217:9090"),
      networkConfiguration:
          NetworkConfiguration(defaultHeaders: {}, timeout: 30),
      analytics: MyAnalytics()));
}

class MyAnalytics extends DUIAnalytics {
  @override
  void onDataSourceError(String dataSourceType, String source, errorInfo) {
    print({
      'dataType': dataSourceType,
      'source': source,
      'metaData': errorInfo.message
    });
  }

  @override
  void onDataSourceSuccess(
      String dataSourceType, String source, metaData, perfData) {
    print({
      'dataType': dataSourceType,
      'source': source,
      'metaData': metaData.toString(),
      'perfData': perfData.toString()
    });
  }

  @override
  void onEvent(List<AnalyticEvent> events) {}
}
