import 'package:flutter/widgets.dart';
import '../../Utils/util_functions.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_switch.dart';
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
    return InternalSwitch(
      enabled: true,
      value: payload.eval<bool>(props.get('value')) ?? false,
      activeColor: makeColor(props.get('activeColor')),
      inactiveThumbColor: makeColor(props.get('inactiveThumbColor')),
      activeTrackColor: makeColor(props.get('activeTrackColor')),
      inactiveTrackColor: makeColor(props.get('inactiveTrackColor')),
    );
  }
}
