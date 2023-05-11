import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/components/bottomNavBar/bottom_navbar.props.dart';
import 'package:flutter/material.dart';

import './components/bottomNavBar/bottom_navbar.dart';

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
  DUIBottomNavbarProps bottomNavbarProps = DUIBottomNavbarProps();
  late List<Widget> screens;
  @override
  void initState() {
    super.initState();
    screens = bottomNavbarProps.screens;
  }

  int index = 0;
  void changeIndex(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: DUIBottomNavbar(
          props: bottomNavbarProps.mockWidget(), onTap: changeIndex),
      body: screens[index],
    );
  }
}
