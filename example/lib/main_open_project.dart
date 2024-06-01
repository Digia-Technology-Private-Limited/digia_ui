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
      developerConfig:
          DeveloperConfig(enableChucker: true, proxyUrl: "192.168.0.118:9090"),
      networkConfiguration: NetworkConfiguration(defaultHeaders: {
        "Authorization":
            "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkZXZpY2UiOjQsImV4cCI6MTcxNjk3NTY3MywiaWF0IjoxNzE2ODg5MjczLCJqayI6ImF1dGgiLCJ1c2VyIjp7ImlkIjoiNjY0NjAxOWE1Yjg5ZWE0ZTU2ZTcxOTlkIiwiaXNRdWl6VGFrZW4iOmZhbHNlLCJwaG9uZSI6IiIsIkludml0ZSI6eyJUb2tlbiI6IiIsIkV4cGlyYXRpb25FcG9jaCI6MH0sIndoYXRzYXBwT3B0aW4iOmZhbHNlLCJhb2ZEZXRhaWxzIjp7InBlcm1hbmVudEFkZHJlc3MiOnt9LCJiaXJ0aENpdHkiOiIiLCJwb2xpdGljYWxseUV4cG9zZWQiOmZhbHNlLCJjdXJyZW50QWRkcmVzcyI6e319LCJDeWJyaWxsYUFjY291bnRJRCI6IiIsIkN5YnJpbGxhQWNjb3VudE9sZElEIjowLCJBY2NvdW50SUQiOiIwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAiLCJDeWJyaWxsYUludmVzdG9ySUQiOjAsIkludmVzdG9ySUQiOiIwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAiLCJPbGRNZW1iZXJQYXJ0bmVyIjowLCJMaW5rZWRpblBob3RvU2F2ZWQiOmZhbHNlLCJpbnZpdGVBY2Nlc3NQaG9uZSI6IiIsImVtcGxveWVyTmFtZSI6IiIsInJlZmVycmFsVXNlcklkIjoiMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwIiwiaXNJbnZpdGVBY2Nlc3NQaG9uZVZlcmlmaWVkIjpmYWxzZSwiYXBwbGljYW50c0FoZWFkIjowLCJpc0ludml0ZVdoYXRzYXBwTm90aWZ5IjpmYWxzZSwicGluIjoiIiwiaW52aXRlRXh0ZW5zaW9uUmVhc29uIjoiIiwicXVpelRva2VuIjoiIiwiY3licmlsbGFNYW5kYXRlSWQiOjAsInJ0YUN5YnJpbGxhTWFuZGF0ZUlkIjowLCJzaXBJRCI6IjAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMCIsIk9uYm9hcmRpbmdNb2RlIjowLCJ1dG0iOnt9LCJvYmplY3RpdmUiOnsiaWQiOiIwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAifSwicG9ydGZvbGlvUmV2aWV3SUQiOiIwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAiLCJwbXNFeHBlcnRDYWxsRGV0YWlscyI6eyJsYXN0VXBkYXRlZFRzIjoiMDAwMS0wMS0wMVQwMDowMDowMFoifSwiYXBwc2ZseWVyVVRNIjp7fSwiY3JlYXRlZEJ5IjoiMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwIiwiZGV6ZXJ2QXBwUmF0aW5nQ2xpY2tlZCI6ZmFsc2UsImFtbERldGFpbHMiOnt9fX0.56q41bzKL2WdNB8uUDGiGmajL8gtHmBpTGEIvzMgwc2b6IfzGfhEwq6dKOVrhHvS3kxtyYIrKPFa1sw8__DB9g"
      }, timeout: 30),
      analytics: MyAnalytics()));
}

class MyAnalytics extends DUIAnalytics {
  @override
  void onEvent(List<Map<String, dynamic>> metaData) {
    print(metaData.toString());
  }

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
}
