import 'package:flutter/material.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import 'icon.dart';

class VWCheckbox extends VirtualLeafStatelessWidget<Props> {
  VWCheckbox({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final value = payload.eval<bool>(props.get('value')) ?? false;
    final size = props.getDouble('size') ?? 24;
    final activeColor = payload.evalColor(props.get('activeColor'));
    final inactiveColor = payload.evalColor(props.get('inactiveColor'));

    final BoxShape shape = switch (props.getString('shape.value')) {
      'circle' => BoxShape.circle,
      _ => BoxShape.rectangle
    };
    final borderRadius = To.borderRadius(props.get('shape.borderRadius'));
    final activeBorderColor = payload.evalColor(props.get('activeBorderColor'));
    final inactiveBorderColor =
        payload.evalColor(props.get('inactiveBorderColor'));
    final borderWidth = props.getDouble('borderWidth');

    final activeIcon = VWIcon(
      props: props.toProps('activeIcon') ?? Props.empty(),
      commonProps: null,
      parent: null,
    );

    final inactiveIcon = VWIcon(
      props: props.toProps('inactiveIcon') ?? Props.empty(),
      commonProps: null,
      parent: null,
    );

    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? activeColor : inactiveColor,
          shape: shape,
          borderRadius: shape == BoxShape.circle ? null : borderRadius,
          border: Border.all(
            width: borderWidth ?? 1.0,
            style: borderWidth == 0.0 ? BorderStyle.none : BorderStyle.solid,
            color: (value ? activeBorderColor : inactiveBorderColor) ??
                Colors.grey,
          ),
        ),
        child: value
            ? activeIcon.toWidget(payload)
            : inactiveIcon.toWidget(payload),
      ),
    );
  }
}
