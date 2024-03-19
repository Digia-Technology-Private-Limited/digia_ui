import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/material.dart';

const String baseUrl = 'http://localhost:5000/hydrator/api';
// const String baseUrl = 'https://app.digia.tech/hydrator/api';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DUIApp(
      digiaAccessKey: "654a07bd58a81f8c6e5c38c5", baseUrl: baseUrl));
}
