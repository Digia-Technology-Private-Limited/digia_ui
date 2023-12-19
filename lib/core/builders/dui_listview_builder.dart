import 'package:digia_ui/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/Utils/dui_widget_registry.dart';
import 'package:digia_ui/core/builders/dui_json_widget_builder.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIListViewBuilder extends DUIWidgetBuilder {
  DUIListViewBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUIListViewBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIListViewBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }

    final children = data.children['children']!;

    return ListView.builder(
        physics: DUIDecoder.toScrollPhysics(data.props['allowScroll']),
        shrinkWrap: NumDecoder.toBoolOrDefault(data.props['shrinkWrap'],
            defaultValue: false),
        itemCount: children.length,
        itemBuilder: (context, index) {
          final builder =
              DUIJsonWidgetBuilder(data: children[index], registry: registry!);
          return builder.build(context);
        });
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for listview');
  }
}
