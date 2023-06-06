import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/charts/line/line_chart.dart';
import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
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
        fontFamily: "Poppins",
        scaffoldBackgroundColor: toColor("light"),
        primaryColor: toColor("light"),
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: toColor("primary"),
          ),
          color: toColor("light"),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
          titleTextStyle: TextStyle(
              color: toColor("text"),
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      title: 'Flutter Demo',
      home: LineChart(
        styleClass:
            DUIStyleClass.fromJson("bgc:white;w:250;h:300;p:35,25,10,10"),
        lineData: samplelineData,
      ),
      // home: DUIPage(initData: ConfigResolver().getfirstPageData()
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   GlobalKey globalKey = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: OnBoarding(OnBoardingProps().mockWidget()),
//     );
//   }
// }
