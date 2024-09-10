import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../components/dui_animation_builder/dui_animation_builder.dart';
import '../json_widget_builder.dart';

class DuiAnimationBuilder extends DUIWidgetBuilder {
  DuiAnimationBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DuiAnimationBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DuiAnimationBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    return DuiAnimationComponent(varName: data.varName, data: data);
  }
}
