import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// const String baseUrl = 'http://localhost:3000/api/v1';
const String baseUrl = 'https://app.digia.tech/api/v1';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DUIApp(
    digiaAccessKey: "66444872c15d1a24707d58c8",
    baseUrl: baseUrl,
    environment: Environment.staging,
    version: 2,
  ));
}
