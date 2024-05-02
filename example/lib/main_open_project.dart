import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// const String baseUrl = 'http://localhost:5000/hydrator/api';
const String baseUrl = 'https://app.digia.tech/hydrator/api';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DUIApp(
      digiaAccessKey: "6629f82db209f5290634b815", baseUrl: baseUrl));
}
