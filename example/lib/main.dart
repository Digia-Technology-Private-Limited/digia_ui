import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DigiaUiSDk(projectId: '659e7ac498e1ff58fef46b89').initializeFromCloud();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DigiaUiSDk.getPage(pageUid: 'homepage-659e7ac498e1ff58fef46b89');
  }
}
