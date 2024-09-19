import 'package:flutter/material.dart';
import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import '../../core/evaluator.dart';
import 'dui_custom_tab_controller.dart';
import 'dui_tab_controller_props.dart';

class DUITabController extends StatelessWidget {
  const DUITabController({
    required this.registry,
    required this.child,
    required this.tabControllerProps,
    super.key,
  });

  final DUIWidgetRegistry registry;
  final DUIWidgetJsonData? child;
  final DuiTabControllerProps tabControllerProps;

  @override
  Widget build(BuildContext context) {
    if (child.isNull) return _emptyChildWidget();
    final builder = DUIJsonWidgetBuilder(data: child!, registry: registry);
    return DUITabControllerProvider(
      dynamicList: toDynamicList(tabControllerProps.dynamicList),
      initialIndex:
          eval<int>(tabControllerProps.initialIndex, context: context) ?? 0,
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

  static List<dynamic>? toDynamicList(dynamic dynamicList) {
    if (dynamicList is! String) {
      return null;
    }
    final parsed = tryJsonDecode(dynamicList) ?? dynamicList;

    if (parsed == null) return null;

    if (parsed is! List) return null;

    return parsed;
  }
}
