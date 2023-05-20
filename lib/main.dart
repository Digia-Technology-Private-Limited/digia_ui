import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/core/dui_page.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load configuration
  await ConfigResolver.initialize('assets/json/config.json');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DUIPage(),
    );
  }
}
