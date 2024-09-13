import 'package:flutter/material.dart';
import 'package:styled_divider/styled_divider.dart';

import '../../Utils/util_functions.dart';
import '../../components/utils/decoder.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';

class VWHorizontalDivider extends VirtualLeafStatelessWidget {
  VWHorizontalDivider({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    return StyledDivider(
      lineStyle: toLineStyle(props['lineStyle']) ?? DividerLineStyle.solid,
      height: payload.eval<double>(props['height']),
      thickness: payload.eval<double>(props['thickness']),
      indent: payload.eval<double>(props['indent']),
      endIndent: payload.eval<double>(props['endIndent']),
      color: makeColor(payload.eval<String>(props['color'])) ?? Colors.black,
    );
  }
}
