import 'package:flutter/material.dart';
import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import '../../core/evaluator.dart';
import 'DUICustomTabController.dart';
import 'dui_tab_view_controller_props.dart';

class DUITabViewController extends StatelessWidget {
  const DUITabViewController({
    required this.registry,
    required this.child,
    required this.tabViewControllerProps,
    super.key,
  });

  final DUIWidgetRegistry registry;
  final DUIWidgetJsonData? child;
  final DuiTabViewControllerProps tabViewControllerProps;

  @override
  Widget build(BuildContext context) {
    if (child.isNull) return _emptyChildWidget();
    final builder = DUIJsonWidgetBuilder(data: child!, registry: registry);
    return DuicustomTabControllerProvider(
      length: tabViewControllerProps.length ?? 0,
      dynamicList: getList(tabViewControllerProps.dynamicList),
      animationDuration: tabViewControllerProps.animationDuration,
      initialIndex:
          eval<int>(tabViewControllerProps.initialIndex, context: context) ?? 0,
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

  List<dynamic> getList(dynamic data) {
    if (data is List) {
      return data;
    }
    return [];
  }
}
