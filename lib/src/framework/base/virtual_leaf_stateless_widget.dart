import 'package:flutter/widgets.dart';

import '../models/common_props.dart';
import '../render_payload.dart';

import '../utils/flutter_type_converters.dart';
import '../utils/widget_util.dart';
import 'virtual_widget.dart';

abstract class VirtualLeafStatelessWidget<T> extends VirtualWidget {
  T props;
  CommonProps? commonProps;

  VirtualLeafStatelessWidget({
    required this.props,
    required this.commonProps,
    required super.parent,
    required super.refName,
  });

  @override
  Widget toWidget(RenderPayload payload) {
    if (commonProps == null) return render(payload);

    final isVisible =
        commonProps?.visibility?.evaluate(payload.exprContext) ?? true;
    if (!isVisible) return empty();

    var current = render(payload);

    // Styling
    current = wrapInContainer(
      payload: payload,
      style: commonProps!.style,
      child: current,
    );

    // Align
    current = wrapInAlign(
      value: commonProps!.align,
      child: current,
    );

    current = wrapInGestureDetector(
      payload: payload,
      actionFlow: commonProps?.onClick,
      child: current,
      borderRadius:
          To.borderRadius(commonProps?.style?.border?['borderRadius']),
    );

    return current;
  }
}
