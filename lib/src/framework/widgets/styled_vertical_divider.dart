import 'package:flutter/widgets.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/types.dart';
import '../../Utils/util_functions.dart';
import '../../components/border/divider_with_pattern/divider_with_pattern.dart';
import '../core/virtual_leaf_stateless_widget.dart';
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
      size: payload.eval<double>(props['width']),
      thickness: payload.eval<double>(props['thickness']),
      indent: payload.eval<double>(props['indent']),
      endIndent: payload.eval<double>(props['endIndent']),
      borderPattern: DUIDecoder.toBorderPattern(
            payload.eval<String>(props['borderPattern']?['value']),
          ) ??
          BorderPattern.solid,
      strokeCap: DUIDecoder.toStrokeCap(
            payload.eval<String>(props['borderPattern']?['strokeCap']),
          ) ??
          StrokeCap.butt,
      dashPattern: DUIDecoder.toDashPattern(
            payload.eval<List<dynamic>>(props['borderPattern']?['dashPattern']),
          ) ??
          [3, 3],
      color: makeColor(payload.eval<String>(props['colorType']?['color'])),
      gradient: toGradiant(
          payload.eval<Map<String, dynamic>>(props['colorType']?['gradient']),
          payload.buildContext),
    );
  }
}
