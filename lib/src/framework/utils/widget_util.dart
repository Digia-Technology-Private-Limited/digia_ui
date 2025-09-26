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

  final heightStr = style.height;
  final widthStr = style.width;
  final isHeightIntrinsic =
      heightStr != null && heightStr.trim().toLowerCase() == 'intrinsic';
  final isWidthIntrinsic =
      widthStr != null && widthStr.trim().toLowerCase() == 'intrinsic';

  if (isHeightIntrinsic || isWidthIntrinsic) {
    if (isHeightIntrinsic && isWidthIntrinsic) {
      current = IntrinsicWidth(child: IntrinsicHeight(child: current));
    } else if (isHeightIntrinsic) {
      current = IntrinsicHeight(child: current);
    } else {
      current = IntrinsicWidth(child: current);
    }
  }

  final height =
      isHeightIntrinsic ? null : style.height?.toHeight(payload.buildContext);
  final width =
      isWidthIntrinsic ? null : style.width?.toWidth(payload.buildContext);

  if (!(width == null && height == null)) {
    current = SizedBox(width: width, height: height, child: current);
  }

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
