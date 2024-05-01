import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/core/builders/dui_json_widget_builder.dart';
import 'package:flutter/material.dart';

class DUIPersistentFooterButtons {
  static List<Widget> listOfButtons(DUIWidgetJsonData data,
      DUIWidgetRegistry? registry, BuildContext context) {
    final persistentFooterButtonsList = data.children['children']!.map((e) {
      final builder = DUIJsonWidgetBuilder(data: e, registry: registry!);
      return builder.build(context);
    }).toList();

    return persistentFooterButtonsList;
  }
}
