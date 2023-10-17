import 'package:digia_ui/Utils/dui_widget_registry.dart';
import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:digia_ui/core/container/dui_container.dart';
import 'package:digia_ui/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

import '../Utils/basic_shared_utils/dui_decoder.dart';

abstract class DUIWidgetBuilder {
  DUIWidgetJsonData data;
  DUIWidgetRegistry? registry;

  DUIWidgetBuilder({required this.data, this.registry});

  Widget build(BuildContext context);

  Widget fallbackWidget() =>
      Text('A widget of type: ${data.type} is not found');

  Widget buildWithContainerProps(BuildContext context) {
    var output = build(context);

    if (data.containerProps.isEmpty) {
      return output;
    }

    // Styling
    final styleClass = DUIStyleClass.fromJson(data.containerProps['style']);
    if (styleClass != null) {
      output = DUIContainer(styleClass: styleClass, child: output);
    }

    // Align
    final alignmentValue =
        DUIDecoder.toAlignmentGeometry(data.containerProps['align']);
    if (alignmentValue != null) {
      output = Align(
        alignment: alignmentValue,
        child: output,
      );
    }

    // Visibility
    // final visiblityBool = NumDecoder.toBool(data.containerProps['visibility']);
    // if (visiblityBool != null) {
    //   output = Visibility(visible: visiblityBool, child: output);
    // }

    return output;
  }
}
