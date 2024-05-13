import 'package:flutter/material.dart';

import '../../Utils/dui_widget_registry.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

final class DUIJsonWidgetBuilder extends DUIWidgetBuilder {
  DUIJsonWidgetBuilder(
      {required DUIWidgetJsonData data, required DUIWidgetRegistry registry})
      : super(data: data, registry: registry);

  @override
  Widget build(BuildContext context) {
    final builder = registry!.getBuilder(data);
    if (builder == null) {
      return fallbackWidget();
    }

    return builder.buildWithContainerProps(context);
  }

  @override
  Widget buildWithContainerProps(BuildContext context) {
    throw 'This should never be called';
  }
}
