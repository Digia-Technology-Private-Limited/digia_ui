import 'package:flutter/material.dart';

import '../../Utils/dui_widget_registry.dart';
import '../json_widget_builder.dart';

final class DUIJsonWidgetBuilder extends DUIWidgetBuilder {
  DUIJsonWidgetBuilder(
      {required super.data, required DUIWidgetRegistry super.registry});

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
