import 'package:flutter/material.dart';

import '../Utils/basic_shared_utils/dui_decoder.dart';
import '../Utils/basic_shared_utils/num_decoder.dart';
import '../core/action/action_handler.dart';
import '../core/action/action_prop.dart';
import '../core/evaluator.dart';

// ignore: non_constant_identifier_names
Widget DUIGestureDetector(
    {required BuildContext context,
    required ActionFlow? actionFlow,
    required Widget child}) {
  if (actionFlow == null || actionFlow.actions.isEmpty) return child;

  if (actionFlow.inkwell) {
    return InkWell(
      onTap: () => ActionHandler.instance
          .execute(context: context, actionFlow: actionFlow),
      child: child,
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
Widget DUIVisibility(
    {dynamic visible, required Widget child, required BuildContext context}) {
  // final value = NumDecoder.toBool(visible);
  final value = eval<bool>(visible, context: context);

  if (value == null) return child;

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
