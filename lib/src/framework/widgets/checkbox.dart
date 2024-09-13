import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';
import 'icon.dart';

class VWCheckbox extends VirtualLeafStatelessWidget {
  VWCheckbox({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final value = payload.eval<bool>(props['value']) ?? false;
    final size = NumDecoder.toDouble(props['size']) ?? 24;
    final activeColor = makeColor(payload.eval<String>(props['activeColor']));
    final inactiveColor =
        makeColor(payload.eval<String>(props['inactiveColor']));
    final BoxShape shape = switch (props.valueFor(keyPath: 'shape.value')) {
      'circle' => BoxShape.circle,
      _ => BoxShape.rectangle
    };
    final borderRadius = DUIDecoder.toBorderRadius(props['shape.borderRadius']);
    final activeBorderColor =
        makeColor(payload.eval<String>(props['activeBorderColor']));
    final inactiveBorderColor =
        makeColor(payload.eval<String>(props['inactiveBorderColor']));
    final borderWidth = NumDecoder.toDouble(props['borderWidth']);

    final activeIcon = VWIcon(
      props: props['activeIcon'] as Map<String, dynamic>,
      commonProps: commonProps,
      parent: this,
    );
    final inactiveIcon = VWIcon(
      props: props['inactiveIcon'] as Map<String, dynamic>,
      commonProps: commonProps,
      parent: this,
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
        child:
            value ? activeIcon.render(payload) : inactiveIcon.render(payload),
      ),
    );
  }
}
