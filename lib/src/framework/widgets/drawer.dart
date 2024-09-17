import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../core/virtual_stateless_widget.dart';
import '../render_payload.dart';

class VWDrawer extends VirtualStatelessWidget {
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
      backgroundColor:
          makeColor(payload.eval<String>(props.get('backgroundColor'))),
      shadowColor: makeColor(payload.eval<String>(props.get('shadowColor'))),
      surfaceTintColor:
          makeColor(payload.eval<String>(props.get('surfaceTintColor'))),
      semanticLabel: payload.eval<String>(props.get('semanticLabel')),
      clipBehavior: DUIDecoder.toClip(props.get('clipBehavior')),
      width: payload.eval<double>(props.get('width')),
      elevation: payload.eval<double>(props.get('elevation')),
      child: child?.toWidget(payload),
    );
  }
}
