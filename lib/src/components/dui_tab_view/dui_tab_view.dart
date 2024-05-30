import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
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

class _DUITabViewState extends State<DUITabView> with TickerProviderStateMixin {
  late TabController _tabController;
  bool isTabScrollable = false;
  TabAlignment tabAlignment = TabAlignment.fill;

  @override
  void initState() {
    super.initState();
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
        length: widget.children.length,
        child: Column(
          children: [
            if (widget.tabViewProps.tabBarPosition == 'top')
              Visibility(
                visible: widget.tabViewProps.hasTabs ?? false,
                child: TabBar(
                  controller: _tabController,
                  padding: DUIDecoder.toEdgeInsets(
                      widget.tabViewProps.tabBarPadding),
                  unselectedLabelColor: widget.tabViewProps.unselectedLabelColor
                      .letIfTrue(toColor),
                  unselectedLabelStyle:
                      toTextStyle(widget.tabViewProps.unselectedLabelStyle),
                  indicatorColor:
                      widget.tabViewProps.indicatorColor.letIfTrue(toColor),
                  labelStyle:
                      toTextStyle(widget.tabViewProps.selectedLabelStyle),
                  dividerColor:
                      widget.tabViewProps.dividerColor.letIfTrue(toColor),
                  labelColor:
                      widget.tabViewProps.selectedLabelColor.letIfTrue(toColor),
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
                  padding: DUIDecoder.toEdgeInsets(
                      widget.tabViewProps.tabBarPadding),
                  unselectedLabelColor: widget.tabViewProps.unselectedLabelColor
                      .letIfTrue(toColor),
                  unselectedLabelStyle:
                      toTextStyle(widget.tabViewProps.unselectedLabelStyle),
                  labelStyle:
                      toTextStyle(widget.tabViewProps.selectedLabelStyle),
                  dividerColor:
                      widget.tabViewProps.dividerColor.letIfTrue(toColor),
                  labelColor:
                      widget.tabViewProps.selectedLabelColor.letIfTrue(toColor),
                  dividerHeight: widget.tabViewProps.dividerHeight,
                  indicator: widget.tabViewProps.indicatorColor != null
                      ? BoxDecoration(
                          color: widget.tabViewProps.indicatorColor
                              .letIfTrue(toColor))
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
      required DUIIconBuilder icon}) {
    return Container(
      padding: DUIDecoder.toEdgeInsets(widget.tabViewProps.tabPadding),
      decoration: BoxDecoration(
        color: isSelected
            ? widget.tabViewProps.selectedBgColor?.letIfTrue(toColor)
            : widget.tabViewProps.nonSelectedBgColor?.letIfTrue(toColor),
        borderRadius:
            DUIDecoder.toBorderRadius(widget.tabViewProps.borderRadius),
        border: Border.all(
          color: widget.tabViewProps.borderColor?.letIfTrue(toColor) ??
              Colors.transparent,
          width: widget.tabViewProps.borderWidth ?? 1.0,
        ),
      ),
      child: widget.tabViewProps.isIconAtLeft == true
          ? Row(children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                    (isSelected
                            ? widget.tabViewProps.selectedLabelColor
                                .letIfTrue(toColor)
                            : widget.tabViewProps.unselectedLabelColor
                                .letIfTrue(toColor)) ??
                        Colors.black,
                    BlendMode.srcIn),
                child: icon.buildWithContainerProps(context),
              ),
              Text(widget.children[index].props['title'] ?? ''),
            ])
          : Column(children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                    (isSelected
                            ? widget.tabViewProps.selectedLabelColor
                                .letIfTrue(toColor)
                            : widget.tabViewProps.unselectedLabelColor
                                .letIfTrue(toColor)) ??
                        Colors.black,
                    BlendMode.srcIn),
                child: icon.buildWithContainerProps(context),
              ),
              Text(widget.children[index].props['title'] ?? ''),
            ]),
    );
  }
}
