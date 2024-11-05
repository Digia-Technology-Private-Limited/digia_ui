import 'package:flutter/material.dart';
import '../actions/base/action_flow.dart';
import '../base/virtual_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWRefreshIndicator extends VirtualStatelessWidget<Props> {
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
    final color = payload.evalColor(props.get('color'));
    final bgColor = payload.evalColor(props.get('backgroundColor'));
    return RefreshIndicator(
      color: color,
      backgroundColor: bgColor,
      displacement: payload.eval<double>(props.get('displacement')) ?? 40,
      edgeOffset: payload.eval<double>(props.get('edgeOffset')) ?? 0.0,
      strokeWidth: payload.eval<double>(props.get('strokeWidth')) ??
          RefreshProgressIndicator.defaultStrokeWidth,
      triggerMode:
          _toTriggerMode(payload.eval<String>(props.get('triggerMode'))),
      onRefresh: () async {
        final onRefresh = ActionFlow.fromJson(props.get('onRefresh'));
        payload.executeAction(onRefresh);
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
