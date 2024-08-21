import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../../core/builders/dui_icon_builder.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import '../../core/evaluator.dart';
import 'customTab/customTabBar.dart';
import 'dui_tab_view_props.dart';

class DUITabView extends StatefulWidget {
  final List<DUIWidgetJsonData> children;
  final DUIWidgetRegistry? registry;
  final DUITabViewProps tabViewProps;
  const DUITabView(
      {required this.children,
      required this.tabViewProps,
      this.registry,
      super.key});

  @override
  State<DUITabView> createState() => _DUITabViewState();
}

class _DUITabViewState extends State<DUITabView> with TickerProviderStateMixin {
  late TabController _tabController;
  late TabBarIndicatorSize _indicatorSize;
  TabBarIndicatorSize? _toTabBarIndicatorSize(dynamic value) => switch (value) {
        'tab' => TabBarIndicatorSize.tab,
        'label' => TabBarIndicatorSize.label,
        _ => null
      };

  @override
  void initState() {
    _initializeTabController();
    _indicatorSize = _toTabBarIndicatorSize(widget.tabViewProps.indicatorProps
            ?.valueFor(keyPath: 'indicatorSize')) ??
        TabBarIndicatorSize.tab;
    super.initState();
  }

  void _initializeTabController() {
    _tabController = TabController(
        initialIndex:
            eval<int>(widget.tabViewProps.initialIndex, context: context) ?? 0,
        length: widget.children.length,
        vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (widget.tabViewProps.tabBarPosition == 'top')
            Visibility(
              visible: widget.tabViewProps.hasTabs ?? false,
              child: TabBarBuilder(
                tabBarType: TabBarMode.indicator,
                iconPosition: toIconPosition(widget.tabViewProps.iconPosition),
                controller: _tabController,
                isScrollable: widget.tabViewProps.tabBarScrollable
                    ?.valueFor(keyPath: 'value'),
                alignment: DUIDecoder.toAlignment(widget
                        .tabViewProps.tabBarScrollable
                        ?.valueFor(keyPath: 'tabAlignment')) ??
                    Alignment.center,
                unselectedLabelColor:
                    makeColor(widget.tabViewProps.unselectedLabelColor),
                labelColor: makeColor(widget.tabViewProps.selectedLabelColor) ??
                    Colors.white,
                labelStyle: toTextStyle(
                        widget.tabViewProps.selectedLabelStyle, context) ??
                    const TextStyle(),
                unselectedLabelStyle: toTextStyle(
                        widget.tabViewProps.unselectedLabelStyle, context) ??
                    const TextStyle(),
                buttonBorderWidth: widget.tabViewProps.buttonProps
                        ?.valueFor(keyPath: 'borderWidth') ??
                    2,
                buttonRadius: widget.tabViewProps.buttonProps
                        ?.valueFor(keyPath: 'borderRadius') ??
                    12,
                labelPadding:
                    DUIDecoder.toEdgeInsets(widget.tabViewProps.labelPadding),
                tabBarPadding:
                    DUIDecoder.toEdgeInsets(widget.tabViewProps.tabBarPadding),
                buttonMargin: DUIDecoder.toEdgeInsets(widget
                    .tabViewProps.buttonProps
                    ?.valueFor(keyPath: 'buttonMargin')),
                buttonBorderColor: makeColor(widget.tabViewProps.buttonProps
                        ?.valueFor(keyPath: 'borderColor')) ??
                    Colors.red,
                buttonIdleBorderColor: makeColor(widget.tabViewProps.buttonProps
                        ?.valueFor(keyPath: 'inActiveBorderColor')) ??
                    Colors.black,
                buttonElevation: widget.tabViewProps.buttonProps
                        ?.valueFor(keyPath: 'elevation') ??
                    2,
                buttonActiveBgColor: makeColor(widget.tabViewProps.buttonProps
                        ?.valueFor(keyPath: 'activeBgColor')) ??
                    Colors.blue,
                buttonInactiveBgColor: makeColor(widget.tabViewProps.buttonProps
                        ?.valueFor(keyPath: 'inactiveBgColor')) ??
                    Colors.grey,
                indicatorColor: makeColor(widget.tabViewProps.indicatorProps
                        ?.valueFor(keyPath: 'indicatorColor')) ??
                    Colors.blue,
                indicatorSize: _indicatorSize,
                dividerColor: makeColor(widget.tabViewProps.indicatorProps
                    ?.valueFor(keyPath: 'dividerColor')),
                dividerHeight: widget.tabViewProps.indicatorProps
                    ?.valueFor(keyPath: 'dividerHeight'),
                tabs: List.generate(widget.children.length, (index) {
                  return TabItem(
                      icon: DUIIconBuilder.fromProps(
                                  props: widget.children[index].props['icon'])
                              ?.build(context) ??
                          DUIIconBuilder.emptyIconWidget(),
                      text: eval<String>(widget.children[index].props['title'],
                              context: context) ??
                          '');
                }),
              ),
              // child: IndicatorTabBar(
              //   isIconColorByState: true,
              //   alignment: Alignment.centerRight,
              //   controller: _tabController,
              //   indicatorSize: _indicatorSize,
              //   isScrollable: false,
              //   labelPadding:
              //       DUIDecoder.toEdgeInsets(widget.tabViewProps.labelPadding),
              //   padding:
              //       DUIDecoder.toEdgeInsets(widget.tabViewProps.tabBarPadding),
              //   iconPosition: IconPosition.top,
              //   labelColor: makeColor(widget.tabViewProps.selectedLabelColor),
              //   unselectedLabelColor:
              //       makeColor(widget.tabViewProps.unselectedLabelColor),
              //   unselectedLabelStyle: toTextStyle(
              //           widget.tabViewProps.unselectedLabelStyle, context) ??
              //       TextStyle(),
              //   // inactiveColor:
              //   //     makeColor(widget.tabViewProps.unselectedLabelColor) ??
              //   //         Colors.black,
              //   indicatorColor: makeColor(widget.tabViewProps.indicatorColor) ??
              //       Colors.blue,
              //   labelStyle: toTextStyle(
              //           widget.tabViewProps.selectedLabelStyle, context) ??
              //       TextStyle(),
              //   dividerColor:
              //       makeColor(widget.tabViewProps.dividerColor) ?? Colors.grey,
              //   // activeColor:
              //   //     makeColor(widget.tabViewProps.selectedLabelColor) ??
              //   //         Colors.blue,
              //   dividerHeight: widget.tabViewProps.dividerHeight ?? 2,
              //   tabs: List.generate(widget.children.length, (index) {
              //     return TabItem(
              //         icon: DUIIconBuilder.fromProps(
              //                     props: widget.children[index].props['icon'])
              //                 ?.build(context) ??
              //             DUIIconBuilder.emptyIconWidget(),
              //         text: eval<String>(widget.children[index].props['title'],
              //                 context: context) ??
              //             '');
              //   }),
              // ),
              // child: TabBar(
              //   controller: _tabController,
              //   indicatorSize: _indicatorSize,
              //   labelPadding:
              //       DUIDecoder.toEdgeInsets(widget.tabViewProps.labelPadding),
              //   padding: DUIDecoder.toEdgeInsets(
              //       widget.tabViewProps.tabBarPadding),
              //   unselectedLabelColor:
              //       makeColor(widget.tabViewProps.unselectedLabelColor),
              //   unselectedLabelStyle: toTextStyle(
              //       widget.tabViewProps.unselectedLabelStyle, context),
              //   indicatorColor: makeColor(widget.tabViewProps.indicatorColor),
              //   labelStyle: toTextStyle(
              //       widget.tabViewProps.selectedLabelStyle, context),
              //   dividerColor: makeColor(widget.tabViewProps.dividerColor),
              //   labelColor: makeColor(widget.tabViewProps.selectedLabelColor),
              //   dividerHeight: widget.tabViewProps.dividerHeight,
              //   tabs: List.generate(widget.children.length, (index) {
              //     final icon = DUIIconBuilder.fromProps(
              //                 props: widget.children[index].props['icon'])
              //             ?.build(context) ??
              //         DUIIconBuilder.emptyIconWidget();
              //     return Column(children: [
              //       icon,
              //       Text(eval<String>(widget.children[index].props['title'],
              //               context: context) ??
              //           ''),
              //     ]);
              //   }),
              // ),
            ),
          Expanded(
              child: TabBarView(
                  controller: _tabController,
                  viewportFraction: widget.tabViewProps.viewportFraction ?? 1.0,
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
                controller: _tabController,
                indicatorSize: _indicatorSize,
                labelPadding:
                    DUIDecoder.toEdgeInsets(widget.tabViewProps.labelPadding),
                padding:
                    DUIDecoder.toEdgeInsets(widget.tabViewProps.tabBarPadding),
                unselectedLabelColor:
                    makeColor(widget.tabViewProps.unselectedLabelColor),
                unselectedLabelStyle: toTextStyle(
                    widget.tabViewProps.unselectedLabelStyle, context),
                labelStyle: toTextStyle(
                    widget.tabViewProps.selectedLabelStyle, context),
                // dividerColor: makeColor(widget.tabViewProps.dividerColor),
                labelColor: makeColor(widget.tabViewProps.selectedLabelColor),
                // dividerHeight: widget.tabViewProps.dividerHeight,
                // indicatorColor: makeColor(widget.tabViewProps.indicatorColor),
                tabs: List.generate(widget.children.length, (index) {
                  final icon = DUIIconBuilder.fromProps(
                              props: widget.children[index].props['icon'])
                          ?.build(context) ??
                      DUIIconBuilder.emptyIconWidget();
                  return Tab(
                    child: Column(children: [
                      icon,
                      Text(eval<String>(widget.children[index].props['title'],
                              context: context) ??
                          ''),
                    ]),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  IconPosition toIconPosition(dynamic value) {
    return switch (value) {
      'top' => IconPosition.top,
      'bottom' => IconPosition.bottom,
      'left' => IconPosition.left,
      'right' => IconPosition.right,
      _ => IconPosition.top
    };
  }
}
