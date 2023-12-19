import 'package:digia_ui/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/Utils/dui_widget_registry.dart';
import 'package:digia_ui/core/builders/dui_json_widget_builder.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUIGridViewBuilder extends DUIWidgetBuilder {
  DUIGridViewBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUIGridViewBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIGridViewBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    final children = data.children['children']!;

    return GridView.builder(
        itemCount: children.length,
        physics: DUIDecoder.toScrollPhysics(data.props['allowScroll']),
        shrinkWrap: NumDecoder.toBoolOrDefault(data.props['shrinkWrap'],
            defaultValue: false),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: NumDecoder.toIntOrDefault(
                data.props['crossAxisCount'],
                defaultValue: 2),
            mainAxisSpacing: NumDecoder.toDoubleOrDefault(
                data.props['mainAxisSpacing'],
                defaultValue: 0.0),
            crossAxisSpacing: NumDecoder.toDoubleOrDefault(
                data.props['crossAxisSpacing'],
                defaultValue: 0.0),
            childAspectRatio: NumDecoder.toDoubleOrDefault(
                data.props['childAspectRatio'],
                defaultValue: 1.0)),
        itemBuilder: (context, index) {
          final builder =
              DUIJsonWidgetBuilder(data: children[index], registry: registry!);
          return builder.build(context);
        });
  }
}
