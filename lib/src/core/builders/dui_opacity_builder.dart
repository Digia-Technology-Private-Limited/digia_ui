import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';

class DuiOpacityBuilder extends DUIWidgetBuilder {
  DuiOpacityBuilder({required super.data});

  static DuiOpacityBuilder create(DUIWidgetJsonData data) {
    return DuiOpacityBuilder(data: data);
  }

  factory DuiOpacityBuilder.fromProps(Map<String, dynamic> props) {
    return DuiOpacityBuilder(
      data: DUIWidgetJsonData(type: 'digia/button', props: props),
    );
  }
  @override
  Widget build(BuildContext context) {
    Widget? child =
        data.children['child']?.first.let((p0) => DUIWidget(data: p0));
    double? opacity = eval<double>(data.props['opacity'], context: context);
    bool? alwaysIncludeSemantics =
        eval<bool>(data.props['alwaysIncludeSemantics'], context: context);

    return Opacity(
        opacity: opacity ?? 1,
        alwaysIncludeSemantics: alwaysIncludeSemantics ?? false,
        child: child);
  }
}
