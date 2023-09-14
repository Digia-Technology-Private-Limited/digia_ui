import 'package:digia_ui/Utils/dui_widget_registry.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

final class DUIJsonWidgetBuilder extends DUIWidgetBuilder {
  DUIJsonWidgetBuilder(
      {required DUIWidgetJsonData data, required DUIWidgetRegistry registry})
      : super(data: data, registry: registry);

  @override
  Widget build(BuildContext context) {
    final builder = registry!.getBuilder(data);
    if (builder == null) {
      return fallbackWidget();
    }

    return builder.buildWithContainerProps(context);
  }

  @override
  Widget buildWithContainerProps(BuildContext context) {
    throw 'This should never be called';
  }
}
