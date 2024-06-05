import 'package:flutter/material.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/util_functions.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';
import 'dui_json_widget_builder.dart';

class DUIDrawerBuilder extends DUIWidgetBuilder {
  DUIDrawerBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUIDrawerBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIDrawerBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:
          (data.props['backgrounColor'] as String?).letIfTrue(toColor),
      shadowColor: (data.props['shadowColor'] as String?).letIfTrue(toColor),
      surfaceTintColor:
          (data.props['surfaceTintColor'] as String?).letIfTrue(toColor),
      semanticLabel: data.props['semanticLabel'] as String?,
      clipBehavior: DUIDecoder.toClip(data.props['clipBehavior']),
      width: eval<double>(data.props['width'], context: context),
      elevation: eval<double>(data.props['elevation'], context: context),
      child: ListView(
        padding: EdgeInsets.zero,
        children: data.children['children']?.map((e) {
              final builder =
                  DUIJsonWidgetBuilder(data: e, registry: registry!);
              return builder.build(context);
            }).toList() ??
            [
              const Text(
                'Children field is Empty!',
                textAlign: TextAlign.center,
              ),
            ],
      ),
    );
  }
}
