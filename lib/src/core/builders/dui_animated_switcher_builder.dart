import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../components/dui_base_stateful_widget.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';

class DUIAnimatedSwitcherBuilder extends DUIWidgetBuilder {
  DUIAnimatedSwitcherBuilder(
      DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUIAnimatedSwitcherBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIAnimatedSwitcherBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    return DuiAnimatedSwitcher(varName: data.varName, data: data);
  }
}

class DuiAnimatedSwitcher extends BaseStatefulWidget {
  const DuiAnimatedSwitcher({
    super.key,
    required super.varName,
    required this.data,
  });
  final DUIWidgetJsonData data;

  @override
  State<DuiAnimatedSwitcher> createState() => _DuiAnimatedSwitcherState();
}

class _DuiAnimatedSwitcherState extends State<DuiAnimatedSwitcher> {
  @override
  Widget build(BuildContext context) {
    final showFirstChild =
        eval<bool>(widget.data.props['showFirstChild'], context: context) ??
            true;
    final animationDuration =
        eval<int>(widget.data.props['animationDuration'], context: context) ??
            100;
    return AnimatedSwitcher(
        duration: Duration(milliseconds: animationDuration),
        child: showFirstChild
            ? widget.data.getChild('firstChild').let((p0) => DUIWidget(
                  data: p0,
                  key: const ValueKey('firstChild'),
                ))
            : widget.data.getChild('secondChild').let((p0) => DUIWidget(
                  data: p0,
                  key: const ValueKey('secondChild'),
                )));
  }
}
