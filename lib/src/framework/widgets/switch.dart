import 'package:flutter/widgets.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_switch.dart';
import '../models/types.dart';
import '../render_payload.dart';

class VWSwitch extends VirtualLeafStatelessWidget {
  VWSwitch({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final activeColor = payload
        .evalColor(ExprOr.fromJson<String>(props.getString('activeColor')));
    final inactiveThumbColor = payload.evalColor(
        ExprOr.fromJson<String>(props.getString('inactiveThumbColor')));
    final activeTrackColor = payload.evalColor(
        ExprOr.fromJson<String>(props.getString('activeTrackColor')));
    final inactiveTrackColor = payload.evalColor(
        ExprOr.fromJson<String>(props.getString('inactiveTrackColor')));

    return InternalSwitch(
      enabled: true,
      value: payload.eval<bool>(props.get('value')) ?? false,
      activeColor: activeColor,
      inactiveThumbColor: inactiveThumbColor,
      activeTrackColor: activeTrackColor,
      inactiveTrackColor: inactiveTrackColor,
    );
  }
}
