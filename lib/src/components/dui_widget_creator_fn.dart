import 'package:flutter/material.dart';

import '../Utils/basic_shared_utils/color_decoder.dart';
import '../Utils/basic_shared_utils/dui_decoder.dart';
import '../Utils/basic_shared_utils/lodash.dart';
import '../Utils/basic_shared_utils/num_decoder.dart';
import '../Utils/extensions.dart';
import '../Utils/util_functions.dart';
import '../core/action/action_handler.dart';
import '../core/action/action_prop.dart';
import '../core/evaluator.dart';
import 'utils/DUIStyleClass/dui_style_class.dart';

// ignore: non_constant_identifier_names
Widget wrapInContainer(
    {required BuildContext context,
    required DUIStyleClass? styleClass,
    required Widget child}) {
  if (styleClass == null) return child;

  final padding = DUIDecoder.toEdgeInsets(styleClass.padding);
  final margin = DUIDecoder.toEdgeInsets(styleClass.margin);
  final bgColor = eval<String>(styleClass.bgColor, context: context);
  final border = toBorder(styleClass.border);
  final borderRadius =
      DUIDecoder.toBorderRadius(styleClass.border?.borderRadius?.toJson());
  final height = styleClass.height?.toHeight(context);
  final width = styleClass.width?.toWidth(context);
  // final clipBehavior = DUIDecoder.toClip(styleClass.clipBehavior);

  // Probably unnecessary Optimisation:
  // Remove Container if all values are null or empty.
  if (padding.isZero() &&
      margin.isZero() &&
      (bgColor == null || !ColorDecoder.isValidColorHex(bgColor)) &&
      border == null &&
      borderRadius.isZero() &&
      height == null &&
      width == null) {
    return child;
  }

  return Container(
    width: width,
    height: height,
    padding: padding,
    margin: margin,
    decoration: BoxDecoration(
        color: bgColor.letIfTrue(toColor),
        border: border,
        borderRadius: borderRadius),
    clipBehavior: !borderRadius.isZero() ? Clip.hardEdge : Clip.none,
    child: child,
  );
}

// ignore: non_constant_identifier_names
Widget DUIGestureDetector(
    {required BuildContext context,
    required ActionFlow? actionFlow,
    required Widget child,
    BorderRadius? borderRadius}) {
  if (actionFlow == null || actionFlow.actions.isEmpty) return child;

  if (actionFlow.inkwell) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => ActionHandler.instance
            .execute(context: context, actionFlow: actionFlow),
        borderRadius: borderRadius,
        child: child,
      ),
    );
  } else {
    return GestureDetector(
      onTap: () => ActionHandler.instance
          .execute(context: context, actionFlow: actionFlow),
      child: child,
    );
  }
}

// ignore: non_constant_identifier_names
Widget DUIAlign({dynamic alignment, required Widget child}) {
  final value = DUIDecoder.toAlignment(alignment);

  if (value == null) return child;

  return Align(
    alignment: value,
    child: child,
  );
}

// ignore: non_constant_identifier_names
Widget DUIAspectRatio({dynamic value, required Widget child}) {
  final aspectRatio = NumDecoder.toDouble(value);

  if (aspectRatio == null) return child;

  return AspectRatio(
    aspectRatio: aspectRatio,
    child: child,
  );
}

// ignore: non_constant_identifier_names
Widget DUIVisibility(
    {dynamic visible, required Widget child, required BuildContext context}) {
  // final value = NumDecoder.toBool(visible);
  final value = eval<bool>(visible, context: context);

  if (value == null || value) return child;

  return Visibility(
    visible: value,
    child: child,
  );
}

// ignore: non_constant_identifier_names
Widget DUIFlexFit(
    {dynamic flex, dynamic expansionType, required Widget child}) {
  if (expansionType == null || expansionType is! String) {
    return child;
  }

  if (expansionType == 'tight') {
    return Expanded(
      flex: NumDecoder.toIntOrDefault(flex, defaultValue: 1),
      child: child,
    );
  }

  if (expansionType == 'loose') {
    return Flexible(
      flex: NumDecoder.toIntOrDefault(flex, defaultValue: 1),
      child: child,
    );
  }

  return child;
}
