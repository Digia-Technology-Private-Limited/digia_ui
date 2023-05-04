import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/components/button/button.dart';
import 'package:digia_ui/components/button/button.props.dart';
import 'package:flutter/material.dart';

void main() async {
  // Load configuration
  await ConfigResolver.initialize('config.json');

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DUIButton(DUIButtonProps().mockWidget()),
    );
  }
}
