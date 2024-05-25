import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// const String baseUrl = 'http://localhost:3000/api/v1';
const String baseUrl = 'https://app.digia.tech/api/v1';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DUIApp(
    digiaAccessKey: "664833da4cd307dedf6955a1",
    baseUrl: baseUrl,
    environment: Environment.staging,
    version: 1,
    defaultHeaders: {
      'Authorization': '',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Date': 'Sat, 25 May 2024 13:39:00 GMT',
      'Content-Length': '69',
      'Connection': 'keep-alive',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Allow-Headers':
          'Content-Type ,Content-Length ,Accept-Encoding ,Authorization ,accept ,Origin ,Cookie ,Cache-Control ,X-Client-App ,X-Client-Package ,X-Client-App ,X-Device ,X-Device-Id ,X-Client-Version, apikey, secret, X-Dezerv-Auth-Type',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Origin': '',
      'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
      'Vary': 'Accept-Encoding, Origin',
      'X-Content-Type-Options': 'nosniff',
      'X-Frame-Options': 'SAMEORIGIN',
      'X-Xss-Protection': '1; mode=block',
    },
  ));
}
