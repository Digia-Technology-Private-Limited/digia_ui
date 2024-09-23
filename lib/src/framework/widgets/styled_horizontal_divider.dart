import 'package:flutter/widgets.dart';

import '../../components/border/divider_with_pattern/divider_with_pattern.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/custom_flutter_types.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWStyledHorizontalDivider extends VirtualLeafStatelessWidget {
  VWStyledHorizontalDivider({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    return DividerWithPattern(
      axis: Axis.horizontal,
      size: payload.eval<double>(props.get('height')),
      thickness: payload.eval<double>(props.get('thickness')),
      indent: payload.eval<double>(props.get('indent')),
      endIndent: payload.eval<double>(props.get('endIndent')),
      borderPattern: To.borderPattern(
            payload.eval<String>(props.get('borderPattern.value')),
          ) ??
          BorderPattern.solid,
      strokeCap: To.strokeCap(
              payload.eval<String>(props.get('borderPattern.strokeCap'))) ??
          StrokeCap.butt,
      dashPattern: To.dashPattern(payload
              .eval<List<dynamic>>(props.get('borderPattern.dashPattern'))) ??
          [3, 3],
      color: payload.evalColor(props.get('colorType.color')),
      gradient: To.gradient(
        props.getMap('colorType.gradient'),
        evalColor: payload.evalColor,
      ),
    );
  }
}
