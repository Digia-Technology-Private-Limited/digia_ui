import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/core/page/dui_page.dart';
import 'package:digia_ui/core/page/dui_page_bloc.dart';
import 'package:digia_ui/core/page/dui_page_event.dart';
import 'package:digia_ui/core/pref/pref_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load configuration
  await ConfigResolver.initialize('assets/json/config.json');
  await PrefUtil.init();
  // await PrefUtil.clearStorage();
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
        scaffoldBackgroundColor: toColor('light'),
        primaryColor: toColor('light'),
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: toColor('light'),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
          ),
          titleTextStyle: TextStyle(
              color: toColor('text'),
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      title: 'Flutter Demo',
      home: BlocProvider(
        create: (context) {
          final resolver = ConfigResolver();
          return DUIPageBloc(
              initData: resolver.getfirstPageData(), resolver: resolver)
            ..add(InitPageEvent());
        },
        child: const DUIPage(),
      ),
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
