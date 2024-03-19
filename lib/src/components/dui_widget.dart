import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:digia_ui/src/core/builders/dui_json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';

import '../Utils/dui_widget_registry.dart';
import '../core/page/props/dui_page_props.dart';
import '../types.dart';

class DUIWidgetScope extends InheritedWidget {
  final DUIIconDataProvider? iconDataProvider;
  final DUIImageProviderFn? imageProviderFn;
  final DUITextStyleBuilder? textStyleBuilder;
  final DUIExternalFunctionHandler? externalFunctionHandler;
  final Map<String, VariableDef>? pageVars;

  const DUIWidgetScope({
    super.key,
    this.iconDataProvider,
    this.imageProviderFn,
    this.textStyleBuilder,
    this.externalFunctionHandler,
    this.pageVars,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant DUIWidgetScope oldWidget) {
    return false;
  }

  static DUIWidgetScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DUIWidgetScope>();
  }
}

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
