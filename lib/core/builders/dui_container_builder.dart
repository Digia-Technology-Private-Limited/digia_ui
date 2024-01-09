import 'package:digia_ui/components/container/dui_container.dart';
import 'package:digia_ui/components/container/dui_container_props.dart';
import 'package:digia_ui/core/json_widget_builder.dart';
import 'package:flutter/material.dart';

import '../page/props/dui_widget_json_data.dart';

class DUIContainerBuilder extends DUIWidgetBuilder {
  DUIContainerBuilder({required super.data});

  static DUIContainerBuilder create(DUIWidgetJsonData data) {
    return DUIContainerBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return DUIContainer(DUIContainerProps.fromJson(data.props));
  }
}
