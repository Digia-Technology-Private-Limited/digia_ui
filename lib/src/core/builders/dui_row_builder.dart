import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';
import 'dui_json_widget_builder.dart';

class DUIRowBuilder extends DUIWidgetBuilder {
  DUIRowBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUIRowBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIRowBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }

    final rowWidget = Row(
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
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: rowWidget,
      );
    }

    return rowWidget;
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for Row');
  }
}
