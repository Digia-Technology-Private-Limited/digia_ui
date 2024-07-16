import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/util_functions.dart';
import '../action/action_handler.dart';
import '../action/action_prop.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';

class DUIRefreshIndicator extends DUIWidgetBuilder {
  DUIRefreshIndicator({required super.data});

  static DUIRefreshIndicator? create(DUIWidgetJsonData data) {
    return DUIRefreshIndicator(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final DUIWidgetJsonData? child = data.children['child']?.firstOrNull;
    return RefreshIndicator(
      color: makeColor(eval<String>(data.props['color'], context: context)),
      backgroundColor: makeColor(
          eval<String>(data.props['backgroundColor'], context: context)),
      displacement:
          eval<double>(data.props['displacement'], context: context) ?? 40,
      edgeOffset:
          eval<double>(data.props['edgeOffset'], context: context) ?? 0.0,
      strokeWidth: eval<double>(data.props['strokeWidth'], context: context) ??
          RefreshProgressIndicator.defaultStrokeWidth,
      triggerMode: _toTriggerMode(data.props['triggerMode']),
      onRefresh: () async {
        final onRefresh = ActionFlow.fromJson(data.props['onRefresh']);
        await ActionHandler.instance
            .execute(context: context, actionFlow: onRefresh);
      },
      child: child != null ? DUIWidget(data: child) : const SizedBox.shrink(),
    );
  }

  RefreshIndicatorTriggerMode _toTriggerMode(String? triggerModeValue) {
    if (triggerModeValue != null) {
      switch (triggerModeValue) {
        case 'onEdge':
          return RefreshIndicatorTriggerMode.onEdge;

        case 'anywhere':
          return RefreshIndicatorTriggerMode.anywhere;

        default:
          return RefreshIndicatorTriggerMode.onEdge;
      }
    } else {
      return RefreshIndicatorTriggerMode.onEdge;
    }
  }
}
