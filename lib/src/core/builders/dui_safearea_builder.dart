import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';

class DUISafeAreaBuilder extends DUIWidgetBuilder {
  DUISafeAreaBuilder({required super.data});

  static DUISafeAreaBuilder? create(DUIWidgetJsonData data) {
    return DUISafeAreaBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    final child = data.children['child']?.firstOrNull;

    final bottom = eval<bool>(data.props['bottom'], context: context) ?? true;
    final top = eval<bool>(data.props['top'], context: context) ?? true;

    return SafeArea(
        bottom: bottom,
        top: top,
        child:
            child.let((p0) => DUIWidget(data: p0)) ?? const SizedBox.shrink());
  }
}
