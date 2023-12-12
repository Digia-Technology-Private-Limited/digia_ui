import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/components/dui_switch/dui_switch.dart';
import 'package:digia_ui/components/dui_switch/dui_switch_props.dart';
import 'package:digia_ui/components/html_view/dui_html_view.dart';
import 'package:digia_ui/components/html_view/dui_htmview_props.dart';
import 'package:digia_ui/core/page/dui_page.dart';
import 'package:digia_ui/core/page/dui_page_bloc.dart';
import 'package:digia_ui/core/page/dui_page_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return FutureBuilder(
        future: ConfigResolver.initializeFromCloud(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Intializing from Cloud...'),
                      LinearProgressIndicator()
                    ],
                  ),
                ),
              ),
            );
          }

          if (snapshot.data != true) {
            return const Scaffold(
              body: SafeArea(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Could not fetch Config.',
                        style: TextStyle(color: Colors.red, fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return BlocProvider(
            create: (context) {
              final resolver = ConfigResolver();
              return DUIPageBloc(
                  initData: resolver.getfirstPageData(), resolver: resolver)
                ..add(InitPageEvent());
            },
            child: DUISwitch(
              DUISwitchProps(
                enabled: true,
                value: true,
                activeColor: '#868CCF',
                inactiveThumbColor: '#168CCF',
                activeTrackColor: '#8623CF',
                inactiveTrackColor: '#568CCF',
              ),
              onChange: (newVal) {},
            ),
          );
        });
  }
}
