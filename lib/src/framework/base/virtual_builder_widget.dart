import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../digia_ui.dart';
import '../models/common_props.dart';
import '../observability/observability_scope.dart';
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
      Widget buildWidget() {
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

        // Margin should always be the last widget
        final margin = To.edgeInsets(commonProps?.style?.margin);
        if (!margin.isZero) {
          current = Padding(padding: margin, child: current);
        }

        return current;
      }

      if (extendHierarchy) {
        final currentContext = payload.observabilityContext;
        final extendedContext =
            currentContext?.extendHierarchy([refName ?? 'DigiaComponent']);

        return ObservabilityScope(
          value: extendedContext,
          child: buildWidget(),
        );
      } else {
        return buildWidget();
      }
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
