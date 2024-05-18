import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String baseUrl = 'http://localhost:3000/api/v1';
// const String baseUrl = 'https://app.digia.tech/hydrator/api';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DUIApp(digiaAccessKey: "65a4e1b85cc29694890b42e8", baseUrl: baseUrl));
}
