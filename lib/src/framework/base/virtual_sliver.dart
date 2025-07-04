import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../models/common_props.dart';
import '../utils/flutter_extensions.dart';
import '../utils/functional_util.dart';
import 'default_error_widget.dart';
import 'virtual_stateless_widget.dart';

abstract class VirtualSliver<T> extends VirtualStatelessWidget<T> {
  VirtualSliver({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
  });

  @override
  Widget toWidget(RenderPayload payload) {
    try {
      if (commonProps == null) return render(payload);
      final isVisible =
          commonProps?.visibility?.evaluate(payload.scopeContext) ?? true;
      if (!isVisible) return SliverToBoxAdapter(child: empty());
      var current = render(payload);

      // Styling
      current = wrapInContainer(
        payload: payload,
        style: commonProps!.style,
        child: current,
      );

      return current;
    } catch (error) {
      if (DigiaUIClient.instance.developerConfig?.host is DashboardHost ||
          kDebugMode) {
        return SliverToBoxAdapter(
          child: DefaultErrorWidget(
              refName: refName, errorMessage: error.toString()),
        );
      } else {
        rethrow;
      }
    }
  }
}

Widget wrapInContainer(
    {required RenderPayload payload,
    required CommonStyle? style,
    required Widget child}) {
  if (style == null) return child;

  Widget current = child;

  if (style.bgColor != null ||
      style.borderRadius != null ||
      style.border != null) {
    final bgColor =
        style.bgColor?.evaluate(payload.scopeContext).maybe(payload.getColor);
    final borderRadius = To.borderRadius(style.borderRadius);
    final border = To.border((
      style: as$<String>(style.border?['borderStyle']),
      width: as$<double>(style.border?['borderWidth']),
      color: as$<String>(style.border?['borderColor']).maybe(payload.getColor),
    ));
    current = ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedSliver(
        decoration: BoxDecoration(
          color: bgColor,
          border: border,
          borderRadius: borderRadius,
        ),
        sliver: current,
      ),
    );
  }

  final padding = To.edgeInsets(style.padding);
  if (!padding.isZero) {
    current = SliverPadding(padding: padding, sliver: current);
  }

  return current;
}
