import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/material.dart';

// const String baseUrl = 'http://localhost:5000/hydrator/api';
const String baseUrl = 'https://app.digia.tech/hydrator/api';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DUIApp(
      digiaAccessKey: "65eec0d0e7923709eb636df1", baseUrl: baseUrl));
}
