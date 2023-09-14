import 'package:digia_ui/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/Utils/dui_widget_registry.dart';
import 'package:digia_ui/core/builders/dui_json_widget_builder.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
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

    return Column(
        mainAxisAlignment: DUIDecoder.toMainAxisAlginmentOrDefault(
            data.props['mainAxisAlignment'],
            defaultValue: MainAxisAlignment.start),
        crossAxisAlignment: DUIDecoder.toCrossAxisAlignmentOrDefault(
            data.props['crossAxisAlignment'],
            defaultValue: CrossAxisAlignment.center),
        children: data.children.map((e) {
          final builder = DUIJsonWidgetBuilder(data: e, registry: registry!);
          return builder.build(context);
        }).toList());
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for Column');
  }
}
