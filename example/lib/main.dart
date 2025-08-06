import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DigiaUIExample());
}

class DigiaUIExample extends StatelessWidget {
  const DigiaUIExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DigiaUIAppBuilder(
      options: InitConfig(
        accessKey: '68930cce1963e358762b546b',
        flavor: Flavor.debug(environment: Environment.production),
      ),
      builder: (context, status) {
        if (status.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (status.hasError) {
          return const Center(child: Text('Error'));
        }
        return MaterialApp(
          home: DUIFactory().createInitialPage(),
        );
      },
    );
  }
}
