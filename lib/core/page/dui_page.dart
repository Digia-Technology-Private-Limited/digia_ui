import 'dart:convert';

import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/core/container/dui_container.dart';
import 'package:digia_ui/core/page/props/dui_page_props.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DUIPage extends StatefulWidget {
  const DUIPage({super.key});

  @override
  State<StatefulWidget> createState() => _DUIPageState();
}

class _DUIPageState extends State<DUIPage> {
  Future<DUIPageProps>? _jsonData() async {
    final response =
        await rootBundle.loadString("assets/temp/subjects_response.json");
    final json = await jsonDecode(response);
    return DUIPageProps.fromJson(json['page']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Test Page")),
      body: FutureBuilder<DUIPageProps>(
          future: _jsonData(),
          builder: (context, snapshot) {
            // TODO: Loader config shall change later
            if (!snapshot.hasData) {
              return Center(
                child: SizedBox(
                  child: CircularProgressIndicator(color: Colors.blue[100]),
                ),
              );
            }

            final listObject = snapshot.data?.layout.body.list;
            final list = listObject?.children;

            if (list == null) {
              return const Center(child: Text("Currently Not supported!!!"));
            }

            final widget = ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];

                  final widgetFromRegistry =
                      DUIWidgetRegistry[item.child.type]?.call(item.child.data);

                  final child = item.wrap
                      ? Wrap(children: [widgetFromRegistry])
                      : widgetFromRegistry;

                  return DUIContainer(
                      styleClass: item.styleClass, child: child);
                });

            return listObject?.styleClass == null
                ? widget
                : DUIContainer(
                    styleClass: listObject?.styleClass, child: widget);
          }),
    );
  }
}
