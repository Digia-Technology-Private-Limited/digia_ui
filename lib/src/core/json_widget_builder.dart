import 'package:flutter/material.dart';

import '../Utils/basic_shared_utils/lodash.dart';
import '../Utils/dui_widget_registry.dart';
import '../components/dui_widget_creator_fn.dart';
import '../components/utils/DUIStyleClass/dui_style_class.dart';
import 'action/action_prop.dart';
import 'container/dui_container.dart';
import 'page/props/dui_widget_json_data.dart';

abstract class DUIWidgetBuilder {
  DUIWidgetJsonData data;
  DUIWidgetRegistry? registry;

  DUIWidgetBuilder({required this.data, this.registry});

  Widget build(BuildContext context);

  Widget fallbackWidget() =>
      Text('A widget of type: ${data.type} is not found');

  Widget buildWithContainerProps(BuildContext context) {
    var output = build(context);
    // MixpanelManager.instance?.track('loadedWidget', properties: {
    //   'data': {
    //     'type': data.type,
    //     'props': data.props,
    //     'container_props': data.containerProps
    //   }
    // });
    if (data.containerProps.isEmpty) {
      return output;
    }

    // Styling
    final styleClass = DUIStyleClass.fromJson(data.containerProps['style']);
    if (styleClass != null) {
      output = DUIContainer(styleClass: styleClass, child: output);
    }

    // Align
    output = DUIAlign(alignment: data.containerProps['align'], child: output);

    final onTapProp = ifNotNull(
        data.containerProps['onClick'] as Map<String, dynamic>?,
        (p0) => ActionFlow.fromJson(p0));

    output = DUIGestureDetector(
        context: context, actionFlow: onTapProp, child: output);

    // Visibility
    output = DUIVisibility(
        visible: data.containerProps['visibility'], child: output);
    return output;
  }
}
