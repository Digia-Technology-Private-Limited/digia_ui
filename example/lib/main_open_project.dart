import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// const String baseUrl = 'http://localhost:3000/api/v1';
const String baseUrl = 'https://dev.digia.tech/api/v1';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DUIApp(
      digiaAccessKey: "664833da4cd307dedf6955a1",
      baseUrl: baseUrl,
      environment: Environment.staging,
      version: 1,
      // developerConfig:
      //     DeveloperConfig(enableChucker: false, proxyUrl: "192.168.1.86:9090"),
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
