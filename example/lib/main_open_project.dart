import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/material.dart';

// const String baseUrl = 'http://localhost:3000/api/v1';
const String baseUrl = 'https://dev.digia.tech/api/v1';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DigiaUI
  final digiaUI = await DigiaUI.createWith(InitConfig(
    accessKey: "681b8775af81b5e02c8d9f0a",
    flavor: Flavor.debug(environment: Environment.development),
    networkConfiguration:
        const NetworkConfiguration(defaultHeaders: {}, timeout: 30),
  ));

  runApp(MyApp(digiaUI: digiaUI));
}

class MyApp extends StatelessWidget {
  final DigiaUI digiaUI;

  const MyApp({super.key, required this.digiaUI});

  @override
  Widget build(BuildContext context) {
    return DigiaUIApp(
      digiaUI: digiaUI,
      analytics: MyAnalytics(),
      builder: (context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        title: 'Digia App',
        home: const DigiaHome(),
      ),
    );
  }
}

class DigiaHome extends StatefulWidget {
  const DigiaHome({super.key});

  @override
  State<DigiaHome> createState() => _DigiaHomeState();
}

class _DigiaHomeState extends State<DigiaHome> {
  @override
  void initState() {
    super.initState();
    _initializeFactory();
  }

  void _initializeFactory() {
    // Initialize DUIFactory with the current configuration
    DUIFactory().initialize();
  }

  @override
  Widget build(BuildContext context) {
    try {
      // Create and return the initial page
      return DUIFactory().createInitialPage();
    } catch (e) {
      // Show error if something goes wrong
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Error loading app',
                  style: TextStyle(color: Colors.red, fontSize: 24),
                ),
                const SizedBox(height: 16),
                Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class MyAnalytics extends DUIAnalytics {
  @override
  void onDataSourceError(String dataSourceType, String source, errorInfo) {
    debugPrint('${{
      'dataType': dataSourceType,
      'source': source,
      'metaData': errorInfo.message
    }}');
  }

  @override
  void onDataSourceSuccess(
      String dataSourceType, String source, metaData, perfData) {
    debugPrint('${{
      'dataType': dataSourceType,
      'source': source,
      'metaData': metaData.toString(),
      'perfData': perfData.toString()
    }}');
  }

  @override
  void onEvent(List<AnalyticEvent> events) {}
}
