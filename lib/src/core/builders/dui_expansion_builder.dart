import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import 'dui_icon_builder.dart';
import 'dui_text_builder.dart';

class DUIExpansionBuilder extends DUIWidgetBuilder {
  DUIExpansionBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUIExpansionBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIExpansionBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }
    final color =
        eval<String>(data.props['expandedBackgroundColor'], context: context)
            .letIfTrue(toColor);
    final collapsedBackgroundColor =
        eval<String>(data.props['collapsedBackgroundColor'], context: context)
            .letIfTrue(toColor);
    final collapsedBorderRadius =
        eval<double>(data.props['collapsedBorderRadius'], context: context);
    final collapsedBorderWidth =
        eval<double>(data.props['collapsedBorderWidth'], context: context);
    final collapsedBorderColor =
        eval<String>(data.props['collapsedBorderColor'], context: context)
            .letIfTrue(toColor);
    final expandedBorderRadius =
        eval<double>(data.props['expandedBorderRadius'], context: context);
    final expandedBorderWidth =
        eval<double>(data.props['expandedBorderWidth'], context: context);
    final expandedBorderColor =
        eval<String>(data.props['expandedBorderColor'], context: context)
            .letIfTrue(toColor);

    final titleWidget = DUITextBuilder.fromProps(props: data.props['title']);

    final leadingWidget1 =
        DUIIconBuilder.fromProps(props: data.props['leadingIcon']);
    // DUIImage? leadingWidget2;
    // if (eval<String>(data.props['leadingImage'], context: context) != null) {
    //   leadingWidget2 =
    //       DUIImage(DUIImageProps.fromJson(data.props['leadingImage']));
    // }
    final trailingCollapsedWidget =
        DUIIconBuilder.fromProps(props: data.props['trailingCollapsed']);
    final trailingExpandedWidget =
        DUIIconBuilder.fromProps(props: data.props['trailingExpanded']);
    bool isExpanded = data.props['initiallyExpanded'] ?? false;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter expandState) {
        return ExpansionTile(
          initiallyExpanded: data.props['initiallyExpanded'] ?? false,
          title: titleWidget.build(context),
          // subtitle: DUITextBuilder.fromProps(props: data.props['subtitle'])
          //     .build(context),
          leading: leadingWidget1.build(context),
          trailing: isExpanded
              ? trailingExpandedWidget.build(context)
              : trailingCollapsedWidget.build(context),
          backgroundColor: color,
          collapsedBackgroundColor: collapsedBackgroundColor,
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(collapsedBorderRadius ?? 12),
            side: BorderSide(
              color: collapsedBorderColor ?? Colors.white,
              width: collapsedBorderWidth ?? 1,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(expandedBorderRadius ?? 12),
            side: BorderSide(
              color: expandedBorderColor ?? Colors.transparent,
              width: expandedBorderWidth ?? 0,
            ),
          ),
          onExpansionChanged: (value) {
            expandState(
              () {
                isExpanded = value;
              },
            );
          },
          children: !(data.children['children'].isNullOrEmpty)
              ? data.children['children']!.map((e) {
                  return DUIWidget(data: e);
                }).toList()
              : [
                  const Text(
                    'Children field is Empty!',
                    textAlign: TextAlign.center,
                  ),
                ],
        );
      },
    );
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for Column');
  }
}
