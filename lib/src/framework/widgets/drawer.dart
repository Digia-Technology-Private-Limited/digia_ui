import 'package:flutter/material.dart';

import '../base/virtual_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWDrawer extends VirtualStatelessWidget<Props> {
  VWDrawer({
    required super.props,
    required super.commonProps,
    required super.parent,
    required super.childGroups,
    super.refName,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    return Drawer(
      backgroundColor: payload.evalColor(props.get('backgroundColor')),
      shadowColor: payload.evalColor(props.get('shadowColor')),
      surfaceTintColor: payload.evalColor(props.get('surfaceTintColor')),
      semanticLabel: payload.eval<String>(props.get('semanticLabel')),
      clipBehavior: To.clip(props.get('clipBehavior')),
      width: payload.eval<double>(props.get('width')),
      elevation: payload.eval<double>(props.get('elevation')),
      child: child?.toWidget(payload),
    );
  }
}
