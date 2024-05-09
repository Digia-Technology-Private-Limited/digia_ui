import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/core/action/action_prop.dart';
import 'package:flutter/material.dart';

import '../Utils/basic_shared_utils/num_decoder.dart';
import '../core/action/action_handler.dart';

// ignore: non_constant_identifier_names
Widget DUIGestureDetector({required BuildContext context, required ActionFlow? actionFlow, required Widget child}) {
  if (actionFlow == null) return child;

  if (actionFlow.inkwell) {
    return InkWell(
      onTap: () => ActionHandler.instance.execute(context: context, actionFlow: actionFlow),
      child: child,
    );
  } else {
    return GestureDetector(
      onTap: () => ActionHandler.instance.execute(context: context, actionFlow: actionFlow),
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
Widget DUIVisibility({dynamic visible, required Widget child}) {
  final value = NumDecoder.toBool(visible);

  if (value == null) return child;

  return Visibility(
    visible: value,
    child: child,
  );
}

// ignore: non_constant_identifier_names
Widget DUIFlexFit({dynamic flex, dynamic expansionType, required Widget child}) {
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
