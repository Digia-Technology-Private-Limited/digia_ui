import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../custom/border_with_pattern.dart';
import '../custom/custom_flutter_types.dart';
import '../models/common_props.dart';
import '../utils/flutter_extensions.dart';
import '../utils/functional_util.dart';
import '../utils/object_util.dart';
import '../utils/types.dart';
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
      final hierarchyContext = buildHierarchyContext(payload);
      final updatedPayload = hierarchyContext != null
          ? payload.copyWith(observabilityContext: hierarchyContext)
          : payload;

      if (commonProps == null) return render(updatedPayload);

      final isVisible =
          commonProps?.visibility?.evaluate(updatedPayload.scopeContext) ??
              true;
      if (!isVisible) return SliverToBoxAdapter(child: empty());

      var current = render(updatedPayload);

      // Styling
      current = wrapInContainer(
        payload: updatedPayload,
        style: commonProps!.style,
        child: current,
      );

      return current;
    } catch (error) {
      if (DigiaUIManager().host is DashboardHost || kDebugMode) {
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
  final padding = To.edgeInsets(style.padding);
  if (!padding.isZero) {
    current = SliverPadding(padding: padding, sliver: current);
  }

  if (style.bgColor != null ||
      style.borderRadius != null ||
      style.border != null) {
    final bgColor =
        style.bgColor?.evaluate(payload.scopeContext).maybe(payload.getColor);
    final borderRadius = To.borderRadius(style.borderRadius);
    final borderWidth = (style.border?['borderWidth'])?.to<double>();
    final borderType = as$<JsonLike>(style.border?['borderType']);
    final borderColor = style.border?['borderColor'];
    final dashPattern = as$<List<Object?>>(borderType?['dashPattern']);
    final borderPattern = as$<String>(borderType?['borderPattern']);
    final borderStrokeCap = as$<String>(borderType?['strokeCap']);
    final borderStrokeAlign = as$<String>(style.border?['strokeAlign']);
    final border = borderPattern == null ||
            (borderWidth == null || borderWidth == 0)
        ? null
        : (borderPattern == 'solid'
            ? To.border((
                style: borderPattern,
                width: borderWidth,
                color: payload.evalColor(borderColor),
                strokeAlign:
                    To.strokeAlign(borderStrokeAlign) ?? StrokeAlign.center,
              ))
            : BorderWithPattern(
                color: payload.evalColor(borderColor) ?? Colors.black,
                strokeWidth: borderWidth,
                strokeAlign:
                    To.strokeAlign(borderStrokeAlign) ?? StrokeAlign.center,
                strokeCap: To.strokeCap(borderStrokeCap) ?? StrokeCap.butt,
                dashPattern: To.dashPattern(jsonEncode(dashPattern)) ?? [3, 1],
                borderPattern:
                    To.borderPattern(borderPattern) ?? BorderPattern.solid,
              ));
    current = DecoratedSliver(
      decoration: BoxDecoration(
        color: bgColor,
        border: border,
        borderRadius: borderRadius,
      ),
      sliver: current,
    );
  }

  return current;
}
