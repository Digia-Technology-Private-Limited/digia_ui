import 'package:flutter/material.dart';
import 'package:styled_divider/styled_divider.dart';

import '../../components/utils/decoder.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWHorizontalDivider extends VirtualLeafStatelessWidget<Props> {
  VWHorizontalDivider({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    return StyledDivider(
      lineStyle:
          toLineStyle(props.getString('lineStyle')) ?? DividerLineStyle.solid,
      height: payload.eval<double>(props.get('height')),
      thickness: payload.eval<double>(props.get('thickness')),
      indent: payload.eval<double>(props.get('indent')),
      endIndent: payload.eval<double>(props.get('endIndent')),
      color: payload.evalColor(props.get('color')) ?? Colors.black,
    );
  }
}
