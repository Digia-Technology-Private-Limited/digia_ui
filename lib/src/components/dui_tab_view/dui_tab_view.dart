import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/util_functions.dart';
import '../../core/builders/dui_icon_builder.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import '../../core/evaluator.dart';
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

class _DUITabViewState extends State<DUITabView> with TickerProviderStateMixin {
  late TabController _tabController;
  bool isTabScrollable = false;
  TabAlignment tabAlignment = TabAlignment.fill;
  late TabBarIndicatorSize _indicatorSize;
  TabBarIndicatorSize? _toTabBarIndicatorSize(dynamic value) => switch (value) {
        'tab' => TabBarIndicatorSize.tab,
        'label' => TabBarIndicatorSize.label,
        _ => null
      };

  @override
  void initState() {
    super.initState();
    _indicatorSize =
        _toTabBarIndicatorSize(widget.tabViewProps.indicatorSize) ??
            TabBarIndicatorSize.tab;
    _initializeTabController();
    _updateTabAlignment();
  }

  void _initializeTabController() {
    _tabController = TabController(length: widget.children.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DUITabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.length != oldWidget.children.length) {
      _tabController.removeListener(_handleTabSelection);
      _tabController.dispose();
      _initializeTabController();
    }
    if (widget.tabViewProps.tabAlignment !=
        oldWidget.tabViewProps.tabAlignment) {
      _updateTabAlignment();
    }
  }

  void _handleTabSelection() {
    setState(() {});
  }

  void _updateTabAlignment() {
    if (widget.tabViewProps.tabAlignment != null) {
      String alignment = widget.tabViewProps.tabAlignment!;
      if (alignment == 'start') {
        isTabScrollable = true;
        tabAlignment = TabAlignment.start;
      } else if (alignment == 'center') {
        isTabScrollable = true;
        tabAlignment = TabAlignment.center;
      } else {
        isTabScrollable = false;
        tabAlignment = TabAlignment.fill;
      }
    } else {
      isTabScrollable = false;
      tabAlignment = TabAlignment.fill;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        initialIndex:
            eval<int>(widget.tabViewProps.initialIndex, context: context) ?? 0,
        length: widget.children.length,
        child: Column(
          children: [
            if (widget.tabViewProps.tabBarPosition == 'top')
              Visibility(
                visible: widget.tabViewProps.hasTabs ?? false,
                child: TabBar(
                  controller: _tabController,
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
                  isScrollable: isTabScrollable,
                  tabAlignment: tabAlignment,
                  tabs: List.generate(widget.children.length, (index) {
                    final icon = DUIIconBuilder.fromProps(
                        props: widget.children[index].props['icon']);
                    final isSelected = _tabController.index == index;
                    return tabData(
                        index: index, isSelected: isSelected, icon: icon);
                  }),
                ),
              ),
            Expanded(
                child: TabBarView(
                    controller: _tabController,
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
                  controller: _tabController,
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
                  indicator: widget.tabViewProps.indicatorColor != null
                      ? BoxDecoration(
                          color: makeColor(widget.tabViewProps.indicatorColor))
                      : null,
                  isScrollable: isTabScrollable,
                  tabAlignment: tabAlignment,
                  tabs: List.generate(widget.children.length, (index) {
                    final icon = DUIIconBuilder.fromProps(
                        props: widget.children[index].props['icon']);
                    final isSelected = _tabController.index == index;
                    return tabData(
                        index: index, isSelected: isSelected, icon: icon);
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget tabData(
      {required int index,
      required bool isSelected,
      required DUIIconBuilder? icon}) {
    return Container(
      padding: DUIDecoder.toEdgeInsets(widget.tabViewProps.tabPadding),
      decoration: BoxDecoration(
        color: isSelected
            ? makeColor(widget.tabViewProps.selectedBgColor)
            : makeColor(widget.tabViewProps.nonSelectedBgColor),
        borderRadius:
            DUIDecoder.toBorderRadius(widget.tabViewProps.borderRadius),
        border: Border.all(
          color:
              makeColor(widget.tabViewProps.borderColor) ?? Colors.transparent,
          width: widget.tabViewProps.borderWidth ?? 1.0,
        ),
      ),
      child: widget.tabViewProps.isIconAtLeft == true
          ? Row(children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                    (isSelected
                            ? makeColor(widget.tabViewProps.selectedLabelColor)
                            : makeColor(
                                widget.tabViewProps.unselectedLabelColor)) ??
                        Colors.black,
                    BlendMode.srcIn),
                child: icon?.build(context) ?? DUIIconBuilder.emptyIconWidget(),
              ),
              Text(widget.children[index].props['title'] ?? ''),
            ])
          : Column(children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                    (isSelected
                            ? makeColor(widget.tabViewProps.selectedLabelColor)
                            : makeColor(
                                widget.tabViewProps.unselectedLabelColor)) ??
                        Colors.black,
                    BlendMode.srcIn),
                child: icon?.build(context) ?? DUIIconBuilder.emptyIconWidget(),
              ),
              Text(widget.children[index].props['title'] ?? ''),
            ]),
    );
  }
}
