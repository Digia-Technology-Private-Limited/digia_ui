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
      value: payload.eval<bool>(props['value']) ?? false,
      activeColor: makeColor(props['activeColor']),
      inactiveThumbColor: makeColor(props['inactiveThumbColor']),
      activeTrackColor: makeColor(props['activeTrackColor']),
      inactiveTrackColor: makeColor(props['inactiveTrackColor']),
    );
  }
}
