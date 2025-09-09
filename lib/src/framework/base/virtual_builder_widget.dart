import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../digia_ui.dart';
import '../models/common_props.dart';
import '../models/props.dart';

import '../utils/flutter_extensions.dart';
import '../utils/widget_util.dart';
import 'default_error_widget.dart';
import 'virtual_widget.dart';

class VirtualBuilderWidget extends VirtualWidget {
  final Widget Function(RenderPayload payload) builder;
  final CommonProps? commonProps;
  final Props? parentProps;
  VirtualBuilderWidget(
    this.builder, {
    required this.commonProps,
    this.parentProps,
    super.refName,
    required super.parent,
  });

  @override
  Widget render(RenderPayload payload) => builder(payload);

  @override
  Widget toWidget(RenderPayload payload) {
    try {
      // Use the widget name (refName or class name) to extend the hierarchy
      final widgetName = refName ?? runtimeType.toString();
      final updatedPayload = payload.withExtendedHierarchy([widgetName]);

      if (commonProps == null) return render(updatedPayload);

      final isVisible =
          commonProps?.visibility?.evaluate(updatedPayload.scopeContext) ??
              true;
      if (!isVisible) return empty();

      var current = render(updatedPayload);

      // Styling
      current = wrapInContainer(
        payload: updatedPayload,
        style: commonProps!.style,
        child: current,
      );

      // Align
      current = wrapInAlign(
        value: commonProps!.align,
        child: current,
      );

      current = wrapInGestureDetector(
        payload: updatedPayload,
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
