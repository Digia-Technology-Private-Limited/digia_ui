import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/core/builders/dui_json_widget_builder.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIColumnBuilder extends DUIWidgetBuilder {
  DUIColumnBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUIColumnBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIColumnBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }

    final columnWidget = Column(
        mainAxisAlignment: DUIDecoder.toMainAxisAlginmentOrDefault(
            data.props['mainAxisAlignment'],
            defaultValue: MainAxisAlignment.start),
        crossAxisAlignment: DUIDecoder.toCrossAxisAlignmentOrDefault(
            data.props['crossAxisAlignment'],
            defaultValue: CrossAxisAlignment.center),
        children: data.children['children']!.map((e) {
          final builder = DUIJsonWidgetBuilder(data: e, registry: registry!);
          return builder.build(context);
        }).toList());

    if (data.props['isScrollable'] == true) {
      return SingleChildScrollView(child: columnWidget);
    }

    return columnWidget;
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for Column');
  }
}
