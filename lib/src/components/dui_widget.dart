import 'dart:convert';

import 'package:flutter/material.dart';

import '../Utils/dui_widget_registry.dart';
import '../core/builders/dui_json_widget_builder.dart';
import '../core/page/props/dui_widget_json_data.dart';

class DUIWidget extends StatelessWidget {
  final DUIWidgetJsonData data;
  final DUIWidgetRegistry registry;

  const DUIWidget(
      {super.key,
      required this.data,
      this.registry = DUIWidgetRegistry.shared});

  factory DUIWidget.fromJson(dynamic json, {Key? key}) {
    if (json is String) {
      final data = DUIWidgetJsonData.fromJson(jsonDecode(json));
      return DUIWidget(key: key, data: data);
    }

    final data = DUIWidgetJsonData.fromJson(json);
    return DUIWidget(key: key, data: data);
  }

  @override
  Widget build(BuildContext context) {
    final builder = DUIJsonWidgetBuilder(data: data, registry: registry);
    return builder.build(context);
  }
}
