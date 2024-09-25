import 'package:flutter/widgets.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_switch.dart';
import '../models/props.dart';
import '../models/types.dart';
import '../render_payload.dart';

class VWSwitch extends VirtualLeafStatelessWidget<Props> {
  VWSwitch({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final activeColor = payload.evalColor(props.getString('activeColor'));
    final inactiveThumbColor =
        payload.evalColor(props.getString('inactiveThumbColor'));
    final activeTrackColor =
        payload.evalColor(props.getString('activeTrackColor'));
    final inactiveTrackColor =
        payload.evalColor(props.getString('inactiveTrackColor'));

    return InternalSwitch(
      enabled: payload.eval<bool>(props.get('enabled')) ?? false,
      value: payload.eval<bool>(props.get('value')) ?? false,
      activeColor: activeColor,
      inactiveThumbColor: inactiveThumbColor,
      activeTrackColor: activeTrackColor,
      inactiveTrackColor: inactiveTrackColor,
    );
  }
}
