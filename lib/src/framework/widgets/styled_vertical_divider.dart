import 'package:flutter/widgets.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/types.dart';
import '../../Utils/util_functions.dart';
import '../../components/border/divider_with_pattern/divider_with_pattern.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';

class VWStyledVerticalDivider extends VirtualLeafStatelessWidget {
  VWStyledVerticalDivider({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    return DividerWithPattern(
      axis: Axis.vertical,
      size: payload.eval<double>(props.get('width')),
      thickness: payload.eval<double>(props.get('thickness')),
      indent: payload.eval<double>(props.get('indent')),
      endIndent: payload.eval<double>(props.get('endIndent')),
      borderPattern: DUIDecoder.toBorderPattern(
            payload.eval<String>(props.get('borderPattern.value')),
          ) ??
          BorderPattern.solid,
      strokeCap: DUIDecoder.toStrokeCap(
            payload.eval<String>(props.get('borderPattern.strokeCap')),
          ) ??
          StrokeCap.butt,
      dashPattern: DUIDecoder.toDashPattern(
            payload.eval<List>(props.get('borderPattern.dashPattern')),
          ) ??
          [3, 3],
      color: makeColor(payload.eval<String>(props.get('colorType.color'))),
      gradient: toGradient(
        props.getMap('colorType.gradient'),
        payload.buildContext,
      ),
    );
  }
}
