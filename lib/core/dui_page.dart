import 'dart:convert';

import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/components/image/image.dart';
import 'package:digia_ui/components/utils/DUICornerRadius/dui_corner_radius.dart';
import 'package:digia_ui/components/utils/DUIInsets/dui_insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DUIPage extends StatefulWidget {
  const DUIPage({super.key});

  @override
  State<StatefulWidget> createState() => _DUIPageState();
}

class _DUIPageState extends State<DUIPage> {
  final Map<String, Function> listRegistry = {
    // 'digia/button': DUIButton.fromJson,
    'digia/text': DUIText.create,
    'digia/image': DUIImage.create,
  };

  Future<dynamic>? _jsonData() async {
    final response =
        await rootBundle.loadString("assets/temp/page_response.json");
    return await jsonDecode(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Test Page")),
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

            final listObject = snapshot.data['page']['layout']['body']['list'];
            final list = listObject['children'];
            if (list is List) {
              return Container(
                  padding: toEdgeInsetsGeometry(
                      DUIInsets.fromJson(listObject['padding'])),
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        final child = item['child'];

                        double? heightFactor;
                        String heightOfChild = item['height'] ?? "0";
                        var lastIndex = heightOfChild.length - 1;
                        if (heightOfChild[lastIndex] == '%') {
                          heightFactor = double.parse(
                                  heightOfChild.substring(0, lastIndex)) /
                              100;
                        }
                        final widget = Container(
                          width: double.infinity,
                          height: heightFactor != null
                              ? MediaQuery.of(context).size.height *
                                  heightFactor
                              : null,
                          alignment: toAlignmentGeometry(item['alignment']),
                          padding: toEdgeInsetsGeometry(
                              DUIInsets.fromJson(item['padding'])),
                          margin: toEdgeInsetsGeometry(
                              DUIInsets.fromJson(item['margin'])),
                          decoration: BoxDecoration(
                              color: toColor(item['bgColor'] ??
                                  DUIConfigConstants.fallbackBgColorHexCode),
                              borderRadius: toBorderRadiusGeometry(
                                  DUICornerRadius.fromJson(
                                      item['cornerRadius']))),
                          child:
                              listRegistry[child['type']]?.call(child['data']),
                        );

                        return widget;
                      }));
            }
            return const Center(child: Text("Not supported!!!"));
          }),
    );
  }
}
