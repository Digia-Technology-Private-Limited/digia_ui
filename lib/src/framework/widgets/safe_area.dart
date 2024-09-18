import 'package:flutter/widgets.dart';

import '../core/virtual_stateless_widget.dart';
import '../core/virtual_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWSafeArea extends VirtualStatelessWidget {
  VWSafeArea({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
    required super.childGroups,
  }) : super(repeatData: null);

  VWSafeArea.withChild(
    VirtualWidget child,
  ) : this(
          props: Props.empty(),
          commonProps: null,
          parent: null,
          refName: null,
          childGroups: {
            'child': [child],
          },
        );

  @override
  Widget render(RenderPayload payload) {
    final bottom = payload.eval<bool>(props.get('bottom')) ?? true;
    final top = payload.eval<bool>(props.get('top')) ?? true;
    final left = payload.eval<bool>(props.get('left')) ?? true;
    final right = payload.eval<bool>(props.get('right')) ?? true;

    return SafeArea(
      bottom: bottom,
      top: top,
      left: left,
      right: right,
      child: child?.toWidget(payload) ?? empty(),
    );
  }
}
