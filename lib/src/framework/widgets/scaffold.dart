import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../internal_widgets/inherited_scaffold_controller.dart';
import '../utils/flutter_extensions.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';
import '../widget_props/icon_props.dart';
import '../widget_props/scaffold_props.dart';
import '../widget_props/sliver_app_bar_props.dart';
import '../widget_props/text_props.dart';
import 'app_bar.dart';
import 'drawer.dart';
import 'icon.dart';
import 'nav_bar_item_custom.dart';
import 'nav_bar_item_default.dart';
import 'navigation_bar.dart';
import 'navigation_bar_custom.dart';
import 'safe_area.dart';
import 'sliver_app_bar.dart';

class VWScaffold extends VirtualStatelessWidget<ScaffoldProps> {
  VWScaffold({
    required super.props,
    required super.commonProps,
    required super.parent,
    required super.childGroups,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final appBarWidget = childOf('appBar');
    final drawer = childOf('drawer')?.toWidget(payload);
    final endDrawer = childOf('endDrawer')?.toWidget(payload);
    final footerButtons =
        childrenOf('persistentFooterButtons')?.toWidgetArray(payload);
    final persistentFooterButtons =
        (footerButtons == null || footerButtons.isEmpty) ? null : footerButtons;

    final bottomNavigationBar =
        childOf('bottomNavigationBar')?.toWidget(payload);

    final themeData = Theme.of(payload.buildContext).copyWith(
      dividerTheme: const DividerThemeData(color: Colors.transparent),
      scaffoldBackgroundColor:
          payload.evalColorExpr(props.scaffoldBackgroundColor),
    );
    final enableSafeArea = payload.evalExpr(props.enableSafeArea) ?? true;

    bool isCollapsibleAppBar = false;
    if (appBarWidget != null && appBarWidget is VWAppBar) {
      isCollapsibleAppBar =
          payload.evalExpr(appBarWidget.props.enableCollapsibleAppBar) ?? false;
    }

    return Theme(
      data: themeData,
      child: bottomNavigationBar == null
          ? Scaffold(
              appBar: isCollapsibleAppBar ? null : _buildAppBar(payload),
              drawer: drawer,
              endDrawer: endDrawer,
              persistentFooterButtons: persistentFooterButtons,
              body: isCollapsibleAppBar
                  ? _buildCollapsibleAppBarBody(payload, enableSafeArea)
                  : _buildRegularBody(payload, enableSafeArea),
            )
          : StatefulBuilder(
              builder: (context, setState) => _ScaffoldWithBottomNav(
                appBarWidget: appBarWidget,
                drawer: drawer,
                endDrawer: endDrawer,
                persistentFooterButtons: persistentFooterButtons,
                isCollapsibleAppBar: isCollapsibleAppBar,
                enableSafeArea: enableSafeArea,
                payload: payload,
                parent: this,
              ),
            ),
    );
  }

  PreferredSizeWidget? _buildAppBar(RenderPayload payload) {
    final child = childOf('appBar');

    if (child == null || child is! VWAppBar) return null;

    final height = child.props.height != null
        ? payload.evalExpr(child.props.height)?.toHeight(payload.buildContext)
        : null;

    return PreferredSize(
      preferredSize: Size.fromHeight(height ?? kToolbarHeight),
      child: VWAppBar(
        props: child.props,
        parent: this,
        leadingIcon: _drawerIcon(),
        trailingIcon: _endDrawerIcon(),
        childGroups: child.childGroups,
      ).toWidget(payload) as PreferredSizeWidget,
    );
  }

  Widget _buildCollapsibleAppBarBody(
      RenderPayload payload, bool enableSafeArea) {
    final appBarWidget = childOf('appBar');
    final bodyWidget = childOf('body');

    if (appBarWidget == null) {
      return empty();
    }

    // Get SliverAppBar properties from AppBar
    final appBarProps = appBarWidget is VWAppBar ? appBarWidget.props : null;

    // Create SliverAppBarProps from AppBarProps
    final sliverAppBarProps = SliverAppBarProps(
      backgroundColor: payload.eval(appBarProps?.backgroundColor),
      centerTitle: payload.eval(appBarProps?.centerTitle),
      collapsedHeight: payload.eval(appBarProps?.collapsedHeight),
      elevation: payload.eval(appBarProps?.elevation),
      expandedHeight: payload.eval(appBarProps?.expandedHeight),
      pinned: payload.eval(appBarProps?.pinned),
      iconColor: payload.eval(appBarProps?.iconColor),
      title: appBarProps?.title ?? TextProps(),
      titleSpacing: payload.eval(appBarProps?.titleSpacing),
      toolbarHeight: payload.eval(appBarProps?.toolbarHeight),
      snap: payload.eval(appBarProps?.snap),
      floating: payload.eval(appBarProps?.floating),
      shadowColor: payload.eval(appBarProps?.shadowColor),
      useFlexibleSpace: payload.eval(appBarProps?.useFlexibleSpace),
      titlePadding: payload.eval(appBarProps?.titlePadding),
      collapseMode: payload.eval(appBarProps?.collapseMode),
      expandedTitleScale: payload.eval(appBarProps?.expandedTitleScale),
      shape: payload.eval(appBarProps?.shape),
      bottomSectionHeight: payload.eval(appBarProps?.bottomSectionHeight),
      bottomSectionWidth: payload.eval(appBarProps?.bottomSectionWidth),
      automaticallyImplyLeading:
          payload.eval(appBarProps?.automaticallyImplyLeading),
      defaultButtonColor: payload.eval(appBarProps?.defaultButtonColor),
      enableCollapsibleAppBar:
          payload.eval(appBarProps?.enableCollapsibleAppBar),
      height: payload.eval(appBarProps?.height),
      trailingIcon: payload.eval(appBarProps?.trailingIcon),
      onTapLeadingIcon: payload.eval(appBarProps?.onTapLeadingIcon),
    );

    Widget body = NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          VWSliverAppBar(
            props: sliverAppBarProps,
            commonProps: null,
            parent: this,
            refName: appBarWidget.refName,
            childGroups: {
              'title': appBarWidget is VirtualStatelessWidget &&
                      appBarWidget.childGroups != null &&
                      appBarWidget.childGroups!.containsKey('title')
                  ? appBarWidget.childGroups!['title']!
                  : [],
              'leading': appBarWidget is VirtualStatelessWidget &&
                      appBarWidget.childGroups != null &&
                      appBarWidget.childGroups!.containsKey('leading')
                  ? appBarWidget.childGroups!['leading']!
                  : [],
              'actions': appBarWidget is VirtualStatelessWidget &&
                      appBarWidget.childGroups != null &&
                      appBarWidget.childGroups!.containsKey('actions')
                  ? appBarWidget.childGroups!['actions']!
                  : [],
              'bottom': appBarWidget is VirtualStatelessWidget &&
                      appBarWidget.childGroups != null &&
                      appBarWidget.childGroups!.containsKey('bottom')
                  ? appBarWidget.childGroups!['bottom']!
                  : [],
              'background': appBarWidget is VirtualStatelessWidget &&
                      appBarWidget.childGroups != null &&
                      appBarWidget.childGroups!.containsKey('background')
                  ? appBarWidget.childGroups!['background']!
                  : [],
            },
          ).toWidget(payload),
        ];
      },
      body: Builder(
        builder: (BuildContext context) {
          return bodyWidget?.toWidget(payload) ?? empty();
        },
      ),
    );

    if (enableSafeArea) {
      body = SafeArea(child: body);
    }

    return body;
  }

  Widget _buildRegularBody(RenderPayload payload, bool enableSafeArea) {
    final body = childOf('body');
    if (body == null) return Container();

    if (enableSafeArea) {
      return VWSafeArea.withChild(body).toWidget(payload);
    }

    return body.toWidget(payload);
  }

  VirtualWidget? _drawerIcon() {
    final child = childOf('drawer');

    if (child == null || child is! VWDrawer) {
      return null;
    }

    return child.props.getMap('drawerIcon').maybe((p0) {
      return VWIcon(
        props: IconProps.fromJson(p0) ?? IconProps.empty(),
        commonProps: null,
        parent: null,
      );
    });
  }

  VirtualWidget? _endDrawerIcon() {
    final child = childOf('endDrawer');

    if (child == null || child is! VWDrawer) {
      return null;
    }

    return child.props.getMap('drawerIcon').maybe((p0) {
      return VWIcon(
        props: IconProps.fromJson(p0) ?? IconProps.empty(),
        commonProps: null,
        parent: null,
      );
    });
  }

  Widget? _buildBodyWithNavBar(
      RenderPayload payload, int bottomNavBarIndex, bool enableSafeArea) {
    final bottomNavBar = childOf('bottomNavigationBar');
    if (bottomNavBar is! VWNavigationBar &&
        bottomNavBar is! VWNavigationBarCustom) {
      return null;
    }

    final isDefaultNavBar = bottomNavBar is VWNavigationBar;
    final navigationItems = isDefaultNavBar
        ? bottomNavBar
            .childrenOf('children')
            ?.whereType<VWNavigationBarItemDefault>()
            .toList()
        : (bottomNavBar as VWNavigationBarCustom)
            .childrenOf('children')
            ?.whereType<VWNavigationBarItemCustom>()
            .toList();

    if (navigationItems == null || navigationItems.isEmpty) return null;

    final entityIds = navigationItems.map((item) {
      if (isDefaultNavBar) {
        return as$<String?>(((item as VWNavigationBarItemDefault)
            .props
            .onSelect?['entity'] as JsonLike?)?['id']);
      } else {
        return as$<String?>(((item as VWNavigationBarItemCustom)
            .props
            .onSelect?['entity'] as JsonLike?)?['id']);
      }
    }).toList();

    if (entityIds.isEmpty || bottomNavBarIndex >= entityIds.length) return null;
    final currentEntityId = entityIds[bottomNavBarIndex];
    if (currentEntityId == null) return null;

    final currentItem = navigationItems.firstWhere((item) {
      if (isDefaultNavBar) {
        return ((item as VWNavigationBarItemDefault).props.onSelect?['entity']
                as JsonLike?)?['id'] ==
            currentEntityId;
      } else {
        return ((item as VWNavigationBarItemCustom).props.onSelect?['entity']
                as JsonLike?)?['id'] ==
            currentEntityId;
      }
    });

    final currentEntityArgs = isDefaultNavBar
        ? (((currentItem as VWNavigationBarItemDefault)
            .props
            .onSelect?['entity'] as JsonLike?)?['args'] as JsonLike?)
        : (((currentItem as VWNavigationBarItemCustom).props.onSelect?['entity']
            as JsonLike?)?['args'] as JsonLike?);

    final Widget entity =
        DefaultActionExecutor.of(payload.buildContext).viewBuilder(
      payload.buildContext,
      currentEntityId,
      currentEntityArgs,
    );
    return enableSafeArea ? SafeArea(child: entity) : entity;
  }
}

class _ScaffoldWithBottomNav extends StatefulWidget {
  final VirtualWidget? appBarWidget;
  final Widget? drawer;
  final Widget? endDrawer;
  final List<Widget>? persistentFooterButtons;
  final bool isCollapsibleAppBar;
  final bool enableSafeArea;
  final RenderPayload payload;
  final VWScaffold parent;

  const _ScaffoldWithBottomNav({
    required this.appBarWidget,
    required this.drawer,
    required this.endDrawer,
    required this.persistentFooterButtons,
    required this.isCollapsibleAppBar,
    required this.enableSafeArea,
    required this.payload,
    required this.parent,
  });

  @override
  State<_ScaffoldWithBottomNav> createState() => _ScaffoldWithBottomNavState();
}

class _ScaffoldWithBottomNavState extends State<_ScaffoldWithBottomNav> {
  int bottomNavBarIndex = 0;

  void onDestinationSelected(int index) {
    setState(() {
      bottomNavBarIndex = index;
    });
  }

  Widget? buildBottomNavigationBar(RenderPayload payload) {
    final child = widget.parent.childOf('bottomNavigationBar');
    if (child == null) return null;
    if (child is! VWNavigationBar && child is! VWNavigationBarCustom) {
      return null;
    }

    if (child is VWNavigationBarCustom) {
      return VWNavigationBarCustom(
        props: child.props,
        commonProps: child.commonProps,
        parent: widget.parent,
        childGroups: child.childGroups,
        selectedIndex: bottomNavBarIndex,
        onDestinationSelected: onDestinationSelected,
      ).toWidget(payload);
    } else {
      child as VWNavigationBar;
      return VWNavigationBar(
        props: child.props,
        commonProps: child.commonProps,
        parent: widget.parent,
        childGroups: child.childGroups,
        selectedIndex: bottomNavBarIndex,
        onDestinationSelected: onDestinationSelected,
      ).toWidget(payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedScaffoldController(
      setCurrentIndex: onDestinationSelected,
      currentIndex: bottomNavBarIndex,
      child: Scaffold(
        appBar: widget.isCollapsibleAppBar
            ? null
            : widget.parent._buildAppBar(widget.payload),
        drawer: widget.drawer,
        endDrawer: widget.endDrawer,
        bottomNavigationBar: buildBottomNavigationBar(widget.payload),
        body: widget.isCollapsibleAppBar
            ? widget.parent._buildCollapsibleAppBarBody(
                widget.payload, widget.enableSafeArea)
            : widget.parent._buildBodyWithNavBar(
                widget.payload, bottomNavBarIndex, widget.enableSafeArea),
        persistentFooterButtons: widget.persistentFooterButtons,
      ),
    );
  }
}
