import 'package:flutter/material.dart';
import 'package:styled_divider/styled_divider.dart';

import '../../Utils/util_functions.dart';
import '../../components/utils/decoder.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';

class VWVerticalDivider extends VirtualLeafStatelessWidget {
  VWVerticalDivider({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    return StyledVerticalDivider(
      lineStyle:
          toLineStyle(props.getString('lineStyle')) ?? DividerLineStyle.solid,
      width: payload.eval<double>(props.get('width')),
      thickness: payload.eval<double>(props.get('thickness')),
      indent: payload.eval<double>(props.get('indent')),
      endIndent: payload.eval<double>(props.get('endIndent')),
      color:
          makeColor(payload.eval<String>(props.get('color'))) ?? Colors.black,
    );
  }
}
