import 'package:flutter/material.dart';

import '../actions/base/action_flow.dart';
import '../models/common_props.dart';
import '../render_payload.dart';
import 'flutter_extensions.dart';
import 'flutter_type_converters.dart';
import 'functional_util.dart';
import 'num_util.dart';

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
  final borderRadius = To.borderRadius(style.border?['borderRadius']);
  final border = To.border((
    style: as$<String>(style.border?['borderStyle']),
    width: as$<double>(style.border?['borderWidth']),
    color: as$<String>(style.border?['borderColor']).maybe(payload.getColor),
  ));
  if (!(bgColor == null && borderRadius.isZero && border == null)) {
    current = ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bgColor,
          border: border,
          borderRadius: borderRadius,
        ),
        child: current,
      ),
    );
  }

  final height = style.height?.toHeight(payload.buildContext);
  final width = style.width?.toWidth(payload.buildContext);
  if (!(width == null && height == null)) {
    current = SizedBox(width: width, height: height, child: current);
  }

  final margin = To.edgeInsets(style.margin);
  if (!margin.isZero) {
    current = Padding(padding: margin, child: current);
  }

  return current;
}

Widget wrapInGestureDetector(
    {required RenderPayload payload,
    required ActionFlow? actionFlow,
    required Widget child,
    BorderRadius? borderRadius}) {
  if (actionFlow == null || actionFlow.actions.isEmpty) return child;

  if (actionFlow.inkwell) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => payload.executeAction(actionFlow),
        borderRadius: borderRadius,
        child: child,
      ),
    );
  } else {
    return GestureDetector(
      onTap: () => payload.executeAction(actionFlow),
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
