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
        return _KeepAliveWrapper(
          keepTabsAlive: duiTabView1Props.keepTabsAlive,
          child: BracketScope(
            variables: [('index', index), ('currentItem', dataList[index])],
            builder: DUIJsonWidgetBuilder(
              data: child!,
              registry: registry ?? DUIWidgetRegistry.shared,
            ),
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

class _KeepAliveWrapper extends StatefulWidget {
  const _KeepAliveWrapper(
      {super.key, required this.child, this.keepTabsAlive = false});
  final Widget child;
  final bool? keepTabsAlive;

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.keepTabsAlive ?? false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
