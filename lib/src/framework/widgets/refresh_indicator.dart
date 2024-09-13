import 'package:flutter/material.dart';
import '../../Utils/util_functions.dart';
import '../../core/action/action_handler.dart';
import '../../core/action/action_prop.dart';
import '../core/virtual_stateless_widget.dart';
import '../render_payload.dart';

class VWRefreshIndicator extends VirtualStatelessWidget {
  VWRefreshIndicator({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    required super.repeatData,
  });

  @override
  Widget render(RenderPayload payload) {
    return RefreshIndicator(
      color: makeColor(payload.eval<String>(props.get('color'))),
      backgroundColor:
          makeColor(payload.eval<String>(props.get('backgroundColor'))),
      displacement: payload.eval<double>(props.get('displacement')) ?? 40,
      edgeOffset: payload.eval<double>(props.get('edgeOffset')) ?? 0.0,
      strokeWidth: payload.eval<double>(props.get('strokeWidth')) ??
          RefreshProgressIndicator.defaultStrokeWidth,
      triggerMode:
          _toTriggerMode(payload.eval<String>(props.get('triggerMode'))),
      onRefresh: () async {
        final onRefresh = ActionFlow.fromJson(props.get('onRefresh'));
        await ActionHandler.instance.execute(
          context: payload.buildContext,
          actionFlow: onRefresh,
        );
      },
      child: child?.toWidget(payload) ?? empty(),
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
