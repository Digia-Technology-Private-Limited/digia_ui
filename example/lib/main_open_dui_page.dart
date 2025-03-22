import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/material.dart';

// const String baseUrl = 'http://localhost:5000/hydrator/api';
const String baseUrl = 'https://dev.digia.tech/api/v1';

void main() async {
  await DigiaUIClient.init(
    accessKey: '67c7f52f627a8d48059039dd',
    flavorInfo: Debug('main'),
    environment: Environment.development.name,
    baseUrl: baseUrl,
    networkConfiguration: NetworkConfiguration(defaultHeaders: {}, timeout: 30),
  );
  DUIFactory().initialize();


  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: Column(
      children: [
        ElevatedButton(onPressed: ()async{
        await  DigiaUIClient.reloadConfig(flavorInfo: Debug('main'));
        }, child: Text('data')),
        Expanded(child: DUIFactory().createInitialPage()),
      ],
    ),
  ));
  // runApp(const DUIApp(
  //     digiaAccessKey: "65fb12a543a6c8e5400e6366", baseUrl: baseUrl));
}
