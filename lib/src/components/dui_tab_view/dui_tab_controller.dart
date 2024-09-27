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
      dynamicList: toDynamicList(tabControllerProps.dynamicList, context) ?? [],
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

  static List? toDynamicList(dynamic dynamicList, BuildContext context) {
    if (dynamicList is List) return dynamicList;

    return eval<List>(
      dynamicList,
      context: context,
      decoder: (p0) {
        final parsed = tryJsonDecode(dynamicList);
        if (parsed is List) return parsed;

        return null;
      },
    );
  }
}
