import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
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

    bool isExpanded = data.props['initiallyExpanded'] ?? false;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter expandState) {
        return ExpansionTile(
          title: DUITextBuilder.fromProps(props: data.props['title'])
              .build(context),
          initiallyExpanded:
              eval<bool>(data.props['initiallyExpanded'], context: context) ??
                  false,
          // subtitle: DUITextBuilder.fromProps(props: data.props['subtitle'])
          //     .build(context),
          leading: DUIIconBuilder.fromProps(props: data.props['leadingIcon'])
              .build(context),
          trailing: isExpanded
              ? DUIIconBuilder.fromProps(props: data.props['trailingExpanded'])
                  .build(context)
              : DUIIconBuilder.fromProps(props: data.props['trailingCollapsed'])
                  .build(context),
          backgroundColor: eval<String>(data.props['expandedBackgroundColor'],
                  context: context)
              .letIfTrue(toColor),
          collapsedBackgroundColor: eval<String>(
                  data.props['collapsedBackgroundColor'],
                  context: context)
              .letIfTrue(toColor),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(eval<double>(
                    data.props['collapsedBorderRadius'],
                    context: context) ??
                12),
            side: BorderSide(
              color: eval<String>(data.props['collapsedBorderColor'],
                          context: context)
                      .letIfTrue(toColor) ??
                  Colors.transparent,
              width: eval<double>(data.props['collapsedBorderWidth'],
                      context: context) ??
                  1,
            ),
          ),
          expandedCrossAxisAlignment: DUIDecoder.toCrossAxisAlignmentOrDefault(
              data.props['expandedCrossAxisAlignment'],
              defaultValue: CrossAxisAlignment.center),
          expandedAlignment: DUIDecoder.toAlignment(
            data.props['expandedAlignment'],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(eval<double>(
                    data.props['expandedBorderRadius'],
                    context: context) ??
                12),
            side: BorderSide(
              color: eval<String>(data.props['expandedBorderColor'],
                          context: context)
                      .letIfTrue(toColor) ??
                  Colors.transparent,
              width: eval<double>(data.props['expandedBorderWidth'],
                      context: context) ??
                  1,
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
    return const Text('Registry not found for Expansion Tile');
  }
}
