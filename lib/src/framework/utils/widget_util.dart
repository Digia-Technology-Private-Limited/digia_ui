import 'dart:convert';

import 'package:flutter/material.dart';

import '../actions/base/action_flow.dart';
import '../custom/border_with_pattern.dart';
import '../custom/custom_flutter_types.dart';
import '../models/common_props.dart';
import '../render_payload.dart';
import 'flutter_extensions.dart';
import 'flutter_type_converters.dart';
import 'functional_util.dart';
import 'num_util.dart';
import 'object_util.dart';
import 'types.dart';

Widget wrapInContainer(
    {required RenderPayload payload,
    required CommonStyle? style,
    required Widget child}) {
  if (style == null) return child;

  Widget current = child;

  final padding = To.edgeInsets(style.padding);
  if (!padding.isZero) {
    current = Padding(padding: padding, child: current);
  }

  final bgColor =
      style.bgColor?.evaluate(payload.scopeContext).maybe(payload.getColor);
  final borderRadius = To.borderRadius(style.borderRadius);
  final border = style.border;
  final borderType = as$<JsonLike>(border?['borderType']);
  final borderColor = border?['borderColor'];
  final borderWidth = (border?['borderWidth'])?.to<double>();
  final dashPattern = as$<List<Object?>>(borderType?['dashPattern']);
  final borderPattern = as$<String>(borderType?['borderPattern']);
  final borderStrokeCap = as$<String>(borderType?['strokeCap']);
  final borderStrokeAlign = as$<String>(border?['strokeAlign']);

  current = DecoratedBox(
    decoration: BoxDecoration(
      color: bgColor,
      border: borderPattern == null || (borderWidth == null || borderWidth == 0)
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
                  dashPattern:
                      To.dashPattern(jsonEncode(dashPattern)) ?? [3, 1],
                  borderPattern:
                      To.borderPattern(borderPattern) ?? BorderPattern.solid,
                )),
      borderRadius: borderRadius,
    ),
    child: current,
  );

  if (!borderRadius.isZero) {
    current = ClipRRect(
      borderRadius: borderRadius,
      child: current,
    );
  }

  current = _applySizing(current, style, payload);

  return current;
}

Widget wrapInGestureDetector({
  required RenderPayload payload,
  required ActionFlow? actionFlow,
  required Widget child,
  BorderRadius? borderRadius,
}) {
  if (actionFlow == null || actionFlow.actions.isEmpty) return child;

  if (actionFlow.inkwell) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => payload.executeAction(
          actionFlow,
          triggerType: 'onTap',
        ),
        borderRadius: borderRadius,
        child: child,
      ),
    );
  } else {
    return GestureDetector(
      onTap: () => payload.executeAction(
        actionFlow,
        triggerType: 'onTap',
      ),
      child: child,
    );
  }
}

Widget wrapInAlign({
  Object? value,
  required Widget child,
}) {
  final alignment = To.alignment(value);

  if (alignment == null) return child;

  return Align(
    alignment: alignment,
    child: child,
  );
}

Widget wrapInAspectRatio({
  Object? value,
  required Widget child,
}) {
  final aspectRatio = NumUtil.toDouble(value);

  if (aspectRatio == null) return child;

  return AspectRatio(
    aspectRatio: aspectRatio,
    child: child,
  );
}

/// Applies intrinsic and explicit sizing to a widget based on style properties.
///
/// This function handles three types of sizing:
/// 1. Intrinsic sizing - when height/width is set to 'intrinsic'
/// 2. Explicit sizing - when height/width has specific values
/// 3. Mixed sizing - when one dimension is intrinsic and the other is explicit
Widget _applySizing(Widget child, CommonStyle style, RenderPayload payload) {
  final isHeightIntrinsic = _isIntrinsic(style.height);
  final isWidthIntrinsic = _isIntrinsic(style.width);

  Widget current = child;

  // Apply intrinsic sizing first if needed
  if (isHeightIntrinsic || isWidthIntrinsic) {
    current =
        _applyIntrinsicSizing(current, isHeightIntrinsic, isWidthIntrinsic);
  }

  // Apply explicit sizing for non-intrinsic dimensions
  final height = isHeightIntrinsic
      ? null
      : style.height
          .maybe((it) => payload.eval(it))
          ?.to<String>()
          ?.toHeight(payload.buildContext);
  final width = isWidthIntrinsic
      ? null
      : style.width
          .maybe((it) => payload.eval(it))
          ?.to<String>()
          ?.toWidth(payload.buildContext);

  if (height != null || width != null) {
    current = SizedBox(
      width: width,
      height: height,
      child: current,
    );
  }

  return current;
}

/// Checks if a dimension string represents intrinsic sizing.
bool _isIntrinsic(String? dimensionStr) {
  return dimensionStr != null &&
      dimensionStr.trim().toLowerCase() == 'intrinsic';
}

/// Wraps a widget with appropriate intrinsic sizing widgets.
Widget _applyIntrinsicSizing(
    Widget child, bool isHeightIntrinsic, bool isWidthIntrinsic) {
  if (isHeightIntrinsic && isWidthIntrinsic) {
    return IntrinsicWidth(child: IntrinsicHeight(child: child));
  } else if (isHeightIntrinsic) {
    return IntrinsicHeight(child: child);
  } else if (isWidthIntrinsic) {
    return IntrinsicWidth(child: child);
  }
  return child;
}
