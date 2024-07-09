import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/util_functions.dart';
import '../../core/builders/dui_icon_builder.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import 'dui_tab_view_props.dart';

class DUITabView extends StatefulWidget {
  final List<DUIWidgetJsonData> children;
  final DUIWidgetRegistry? registry;
  final DUITabViewProps tabViewProps;
  const DUITabView(
      {required this.children,
      required this.tabViewProps,
      this.registry,
      Key? key})
      : super(key: key);

  @override
  State<DUITabView> createState() => _DUITabViewState();
}

class _DUITabViewState extends State<DUITabView> {
  late TabBarIndicatorSize _indicatorSize;
  TabBarIndicatorSize? _toTabBarIndicatorSize(dynamic value) => switch (value) {
        'tab' => TabBarIndicatorSize.tab,
        'label' => TabBarIndicatorSize.label,
        _ => null
      };

  @override
  void initState() {
    _indicatorSize =
        _toTabBarIndicatorSize(widget.tabViewProps.indicatorSize) ??
            TabBarIndicatorSize.tab;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: widget.children.length,
        child: Column(
          children: [
            if (widget.tabViewProps.tabBarPosition == 'top')
              Visibility(
                visible: widget.tabViewProps.hasTabs ?? false,
                child: TabBar(
                  indicatorSize: _indicatorSize,
                  labelPadding:
                      DUIDecoder.toEdgeInsets(widget.tabViewProps.labelPadding),
                  padding: DUIDecoder.toEdgeInsets(
                      widget.tabViewProps.tabBarPadding),
                  unselectedLabelColor:
                      makeColor(widget.tabViewProps.unselectedLabelColor),
                  unselectedLabelStyle: toTextStyle(
                      widget.tabViewProps.unselectedLabelStyle, context),
                  indicatorColor: makeColor(widget.tabViewProps.indicatorColor),
                  labelStyle: toTextStyle(
                      widget.tabViewProps.selectedLabelStyle, context),
                  dividerColor: makeColor(widget.tabViewProps.dividerColor),
                  labelColor: makeColor(widget.tabViewProps.selectedLabelColor),
                  dividerHeight: widget.tabViewProps.dividerHeight,
                  tabs: List.generate(widget.children.length, (index) {
                    final icon = DUIIconBuilder.fromProps(
                                props: widget.children[index].props['icon'])
                            ?.build(context) ??
                        DUIIconBuilder.emptyIconWidget();
                    return Column(children: [
                      icon,
                      Text(widget.children[index].props['title'] ?? ''),
                    ]);
                  }),
                ),
              ),
            Expanded(
                child: TabBarView(
                    viewportFraction:
                        widget.tabViewProps.viewportFraction ?? 1.0,
                    physics: widget.tabViewProps.isScrollable ?? false
                        ? const AlwaysScrollableScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    children: widget.children.map((e) {
                      final builder = DUIJsonWidgetBuilder(
                          data: e, registry: widget.registry!);
                      return builder.build(context);
                    }).toList())),
            if (widget.tabViewProps.tabBarPosition == 'bottom')
              Visibility(
                visible: widget.tabViewProps.hasTabs ?? false,
                child: TabBar(
                  indicatorSize: _indicatorSize,
                  labelPadding:
                      DUIDecoder.toEdgeInsets(widget.tabViewProps.labelPadding),
                  padding: DUIDecoder.toEdgeInsets(
                      widget.tabViewProps.tabBarPadding),
                  unselectedLabelColor:
                      makeColor(widget.tabViewProps.unselectedLabelColor),
                  unselectedLabelStyle: toTextStyle(
                      widget.tabViewProps.unselectedLabelStyle, context),
                  labelStyle: toTextStyle(
                      widget.tabViewProps.selectedLabelStyle, context),
                  dividerColor: makeColor(widget.tabViewProps.dividerColor),
                  labelColor: makeColor(widget.tabViewProps.selectedLabelColor),
                  dividerHeight: widget.tabViewProps.dividerHeight,
                  indicatorColor: makeColor(widget.tabViewProps.indicatorColor),
                  tabs: List.generate(widget.children.length, (index) {
                    final icon = DUIIconBuilder.fromProps(
                                props: widget.children[index].props['icon'])
                            ?.build(context) ??
                        DUIIconBuilder.emptyIconWidget();
                    return Column(children: [
                      icon,
                      Text(widget.children[index].props['title'] ?? ''),
                    ]);
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
