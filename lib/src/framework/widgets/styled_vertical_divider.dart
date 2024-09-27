import 'package:flutter/widgets.dart';

import '../../components/border/divider_with_pattern/divider_with_pattern.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/custom_flutter_types.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWStyledVerticalDivider extends VirtualLeafStatelessWidget<Props> {
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
      borderPattern: To.borderPattern(
              payload.eval<String>(props.get('borderPattern.value'))) ??
          BorderPattern.solid,
      strokeCap: To.strokeCap(
              payload.eval<String>(props.get('borderPattern.strokeCap'))) ??
          StrokeCap.butt,
      dashPattern: To.dashPattern(
              payload.eval<List>(props.get('borderPattern.dashPattern'))) ??
          [3, 3],
      color: payload.evalColor(props.get('colorType.color')),
      gradient: To.gradient(
        props.getMap('colorType.gradient'),
        evalColor: payload.evalColor,
      ),
    );
  }
}
