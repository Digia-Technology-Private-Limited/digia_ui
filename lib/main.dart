import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/pages/onboarding/onboarding.dart';
import 'package:digia_ui/pages/onboarding/onboarding_props.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: getTextColor("light"),
        primaryColor: getTextColor("light"),
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: getTextColor("primary"),
          ),
          color: getTextColor("light"),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          titleTextStyle: TextStyle(
              color: getTextColor("text"),
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      title: 'Flutter Demo',
      home: OnBoarding(OnBoardingProps().mockWidget()),
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
      body: OnBoarding(OnBoardingProps().mockWidget()),
    );
  }
}
