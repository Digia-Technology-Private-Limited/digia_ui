import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../digia_ui.dart';
import '../models/common_props.dart';
import '../utils/flutter_extensions.dart';
import '../utils/widget_util.dart';
import 'default_error_widget.dart';
import 'virtual_widget.dart';

class VirtualBuilderWidget extends VirtualWidget {
  final Widget Function(RenderPayload payload) builder;
  final CommonProps? commonProps;
  final bool extendHierarchy;

  VirtualBuilderWidget(
    this.builder, {
    required this.commonProps,
    super.parentProps,
    super.refName,
    required super.parent,
    this.extendHierarchy = true,
  });

  @override
  Widget render(RenderPayload payload) => builder(payload);

  @override
  Widget toWidget(RenderPayload payload) {
    try {
      // Extend hierarchy if requested and refName exists
      final extendedPayload = (extendHierarchy && refName != null)
          ? payload.withExtendedHierarchy(refName!)
          : payload;

      if (commonProps == null) return render(extendedPayload);

      final isVisible =
          commonProps?.visibility?.evaluate(extendedPayload.scopeContext) ??
              true;
      if (!isVisible) return empty();

      var current = render(extendedPayload);

      // Styling
      current = wrapInContainer(
        payload: extendedPayload,
        style: commonProps!.style,
        child: current,
      );

      // Align
      current = wrapInAlign(
        value: commonProps!.align,
        child: current,
      );

      current = wrapInGestureDetector(
        payload: extendedPayload,
        actionFlow: commonProps?.onClick,
        child: current,
        borderRadius: To.borderRadius(commonProps?.style?.borderRadius),
      );

      // Margin should always be the last widget
      final margin = To.edgeInsets(commonProps?.style?.margin);
      if (!margin.isZero) {
        current = Padding(padding: margin, child: current);
      }

      return current;
    } catch (error) {
      if (DigiaUIManager().host is DashboardHost || kDebugMode) {
        return DefaultErrorWidget(
            refName: refName, errorMessage: error.toString());
      } else {
        rethrow;
      }
    }
  }
}
