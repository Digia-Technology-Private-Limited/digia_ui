import 'dart:math';

import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../../core/bracket_scope_provider.dart';
import '../../core/builders/common.dart';
import '../../core/builders/dui_icon_builder.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import '../../core/evaluator.dart';
import 'customTab/customTabBar.dart';
import 'dui_tab_view_props.dart';

class DUITabView extends StatefulWidget {
  final DUIWidgetJsonData data;
  final DUIWidgetRegistry? registry;
  final DUITabViewProps tabViewProps;
  const DUITabView(
      {required this.data,
      required this.tabViewProps,
      this.registry,
      super.key});

  @override
  State<DUITabView> createState() => _DUITabViewState();
}

class _DUITabViewState extends State<DUITabView> with TickerProviderStateMixin {
  late TabController _tabController;
  late TabBarIndicatorSize _indicatorSize;
  late List<DUIWidgetJsonData> children;
  late bool generateChildrenDynamically;
  List<dynamic> dynamicItem = [];
  TabBarIndicatorSize? _toTabBarIndicatorSize(dynamic value) => switch (value) {
        'tab' => TabBarIndicatorSize.tab,
        'label' => TabBarIndicatorSize.label,
        _ => null
      };

  @override
  void initState() {
    children = widget.data.children['children'] ?? [];
    dynamicItem =
        createDataItemsForDynamicChildren(data: widget.data, context: context);
    generateChildrenDynamically =
        widget.data.dataRef.isNotEmpty && widget.data.dataRef['kind'] != null;
    if (generateChildrenDynamically) {
      dynamicItem = dynamicItem.where((e) {
        final condition =
            eval<bool>(e.props['condition'], context: context) ?? false;
        return condition;
      }).map((e) {
        return e;
      }).toList();
    } else {
      children = children.where((e) {
        final condition =
            eval<bool>(e.props['condition'], context: context) ?? false;
        return condition;
      }).map((e) {
        return e;
      }).toList();
    }
    _initializeTabController();
    _indicatorSize = _toTabBarIndicatorSize(widget.tabViewProps.buttonProps
            ?.valueFor(keyPath: 'indicatorSize')) ??
        TabBarIndicatorSize.tab;
    super.initState();
  }

  void _initializeTabController() {
    _tabController = TabController(
        initialIndex:
            eval<int>(widget.tabViewProps.initialIndex, context: context) ?? 0,
        length: children.length,
        vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return _emptyChildWidget();
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Visibility(
            visible: widget.tabViewProps.hasTabs ?? false,
            child: TabBarBuilder(
              tabBarType: toTabBar(
                  widget.tabViewProps.buttonProps?.valueFor(keyPath: 'value')),
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
              indicatorColor: makeColor(widget.tabViewProps.buttonProps
                      ?.valueFor(keyPath: 'indicatorColor')) ??
                  Colors.blue,
              indicatorSize: _indicatorSize,
              dividerColor: makeColor(widget.tabViewProps.buttonProps
                  ?.valueFor(keyPath: 'dividerColor')),
              dividerHeight: widget.tabViewProps.buttonProps
                  ?.valueFor(keyPath: 'dividerHeight'),
              tabs: List.generate(children.length, (index) {
                return TabItem(
                    icon: DUIIconBuilder.fromProps(
                                props: children[index].props['icon'])
                            ?.build(context) ??
                        DUIIconBuilder.emptyIconWidget(),
                    text: eval<String>(children[index].props['title'],
                            context: context) ??
                        '');
              }),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              viewportFraction: widget.tabViewProps.viewportFraction ?? 1.0,
              physics: widget.tabViewProps.isScrollable ?? false
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              // children: children.map((e) {
              //   final builder =
              //       DUIJsonWidgetBuilder(data: e, registry: widget.registry!);
              //   return builder.build(context);
              // }).toList(),
              children: generateChildrenDynamically
                  ? List.generate(dynamicItem.length, (index) {
                      final childToRepeat = children.first;
                      return BracketScope(
                        variables: [
                          ('index', index),
                          ('currentItem', dynamicItem[index])
                        ],
                        builder: DUIJsonWidgetBuilder(
                          data: childToRepeat,
                          registry: widget.registry ?? DUIWidgetRegistry.shared,
                        ),
                      );
                    })
                  : children.map((e) {
                      return DUIJsonWidgetBuilder(
                        data: e,
                        registry: widget.registry ?? DUIWidgetRegistry.shared,
                      ).build(context);
                    }).toList(),
            ),
          ),
        ],
      ),
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

  TabBarMode toTabBar(dynamic value) {
    return switch (value) {
      'indicator' => TabBarMode.indicator,
      'button' => TabBarMode.button,
      _ => TabBarMode.indicator
    };
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
