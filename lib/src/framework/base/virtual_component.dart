import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../digia_ui.dart';
import '../models/common_props.dart';
import '../models/props.dart';
import '../utils/widget_util.dart';
import 'default_error_widget.dart';
import 'virtual_widget.dart';

class VirtualCommonWrapper extends VirtualWidget {
  final Widget Function(RenderPayload payload) builder;
  final CommonProps? commonProps;
  final Props? parentProps;
  VirtualCommonWrapper({
    required this.builder,
    required this.commonProps,
    this.parentProps,
    required super.parent,
    required super.refName,
  });

  @override
  Widget render(RenderPayload payload) => builder(payload);

  @override
  Widget toWidget(RenderPayload payload) {
    try {
      if (commonProps == null) return render(payload);
      final isVisible =
          commonProps?.visibility?.evaluate(payload.scopeContext) ?? true;
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
        borderRadius: To.borderRadius(commonProps?.style?.borderRadius),
      );

      return current;
    } catch (error) {
      if (DigiaUIClient.instance.developerConfig?.host is DashboardHost ||
          kDebugMode) {
        return DefaultErrorWidget(
            refName: refName, errorMessage: error.toString());
      } else {
        rethrow;
      }
    }
  }
}
