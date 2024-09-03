import 'package:flutter/material.dart';
import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import '../../core/evaluator.dart';
import 'dui_tab_view_controller_props.dart';

class DUITabViewController extends StatefulWidget {
  const DUITabViewController({
    required this.registry,
    required this.child,
    required this.tabViewControllerProps,
    Key? key,
  }) : super(key: key);

  final DUIWidgetRegistry registry;
  final DUIWidgetJsonData? child;
  final DuiTabViewControllerProps tabViewControllerProps;

  @override
  State<DUITabViewController> createState() => _DUITabViewControllerState();
}

class _DUITabViewControllerState extends State<DUITabViewController> {
  @override
  Widget build(BuildContext context) {
    if (widget.child.isNull) return _emptyChildWidget();
    final builder =
        DUIJsonWidgetBuilder(data: widget.child!, registry: widget.registry);
    return DefaultTabController(
      length: widget.tabViewControllerProps.length ?? 0,
      initialIndex: eval<int>(widget.tabViewControllerProps.initialIndex,
              context: context) ??
          0,
      child: builder.build(context),
    );
  }

  Widget _emptyChildWidget() {
    return const Center(
      child: Text(
        'Child field is Empty!',
        textAlign: TextAlign.center,
      ),
    );
  }
}
