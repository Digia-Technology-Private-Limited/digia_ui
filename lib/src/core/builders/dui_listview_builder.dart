import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/Utils/extensions.dart';
import 'package:digia_ui/src/core/builders/dui_json_widget_builder.dart';
import 'package:digia_ui/src/core/json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
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

    return !children.isNullOrEmpty
        ? ListView.builder(
            physics: DUIDecoder.toScrollPhysics(data.props['allowScroll']),
            shrinkWrap: NumDecoder.toBoolOrDefault(data.props['shrinkWrap'],
                defaultValue: false),
            itemCount: children.length,
            itemBuilder: (context, index) {
              final builder = DUIJsonWidgetBuilder(
                  data: children[index], registry: registry!);
              return builder.build(context);
            })
        : const Text(
            'Children field is Empty!',
            textAlign: TextAlign.center,
          );
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for listview');
  }
}
