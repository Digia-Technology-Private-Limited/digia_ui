import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../digia_ui.dart';
import '../models/common_props.dart';
import '../models/props.dart';
import '../utils/flutter_extensions.dart';
import '../utils/widget_util.dart';
import 'default_error_widget.dart';
import 'virtual_widget.dart';

abstract class VirtualLeafStatelessWidget<T> extends VirtualWidget {
  T props;
  CommonProps? commonProps;
  Props? parentProps;

  VirtualLeafStatelessWidget({
    required this.props,
    required this.commonProps,
    required super.parent,
    required super.refName,
    this.parentProps,
  });

  @override
  Widget toWidget(RenderPayload payload) {
    try {
      final hierarchyContext = buildHierarchyContext(payload);
      final updatedPayload = hierarchyContext != null
          ? payload.copyWith(observabilityContext: hierarchyContext)
          : payload;
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
