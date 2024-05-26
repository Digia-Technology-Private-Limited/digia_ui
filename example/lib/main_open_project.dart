import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// const String baseUrl = 'http://localhost:3000/api/v1';
const String baseUrl = 'https://dev.digia.tech/api/v1';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DUIApp(
    digiaAccessKey: "664833da4cd307dedf6955a1",
    baseUrl: baseUrl,
    environment: Environment.staging,
    version: 1,
  ));
}
