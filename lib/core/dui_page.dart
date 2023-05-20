import 'dart:convert';

import 'package:digia_ui/components/button/button.dart';
import 'package:digia_ui/components/image/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DUIPage extends StatefulWidget {
  const DUIPage({super.key});

  @override
  State<StatefulWidget> createState() => _DUIPageState();
}

class _DUIPageState extends State<DUIPage> {
  final Map<String, Function> listRegistry = {
    'digia/button': DUIButton.fromJson,
    'digia/image': DUIImage.fromJson,
  };

  Future<dynamic>? _jsonData() async {
    final response =
        await rootBundle.loadString("assets/temp/page_response.json");
    return await jsonDecode(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Page")),
      body: FutureBuilder<dynamic>(
        future: _jsonData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                child: CircularProgressIndicator(color: Colors.blue[100]),
              ),
            );
          }

          final list = snapshot.data['list'];
          if (list is List) {
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  return Container(
                    child: listRegistry[item['type']]?.call(item['data']),
                  );
                });
          }

          return const Center(child: Text("Failure!!!"));
        },
      ),
    );
  }
}
