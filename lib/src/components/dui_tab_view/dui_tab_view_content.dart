import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../core/bracket_scope_provider.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import 'dui_custom_tab_controller.dart';
import 'dui_tab_view_content_props.dart';

class DUITabViewContent extends StatelessWidget {
  DUITabViewContent({
    super.key,
    required this.registry,
    required this.data,
    required this.duiTabView1Props,
  });

  final DUIWidgetRegistry? registry;
  final DUIWidgetJsonData data;
  final DUITabViewContentProps duiTabView1Props;

  late DUICustomTabController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = DUITabControllerProvider.of(context);
    final child = ((data.children['child'] ?? []).isEmpty)
        ? null
        : data.children['child']?.first;

    if (child.isNull) return _emptyChildWidget();
    final dataList = _controller.dynamicList ?? [];
    return TabBarView(
      controller: _controller,
      physics: duiTabView1Props.isScrollable ?? false
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      viewportFraction: duiTabView1Props.viewportFraction ?? 1.0,
      children: List.generate(dataList.length, (index) {
        return BracketScope(
          variables: [('index', index), ('currentItem', dataList[index])],
          builder: DUIJsonWidgetBuilder(
            data: child!,
            registry: registry ?? DUIWidgetRegistry.shared,
          ),
        );
      }),
    );
  }

  Widget _emptyChildWidget() {
    return const Center(
      child: Text(
        'Children field is Empty!',
        textAlign: TextAlign.center,
      ),
    );
  }
}
