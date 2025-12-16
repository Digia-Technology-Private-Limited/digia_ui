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
import 'nested_scroll_view.dart';
import 'safe_area.dart';
import 'sliver_app_bar.dart';

class VWScaffold extends VirtualStatelessWidget<ScaffoldProps> {
  VWScaffold({
    required super.props,
    required super.commonProps,
    super.parentProps,
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
    final resizeToAvoidBottomInset =
        payload.evalExpr(props.resizeToAvoidBottomInset) ?? true;

    bool isCollapsibleAppBar = false;
    if (appBarWidget != null && appBarWidget is VWAppBar) {
      isCollapsibleAppBar =
          payload.evalExpr(appBarWidget.props.enableCollapsibleAppBar) ?? false;
    }

    return Theme(
      data: themeData,
      child: bottomNavigationBar == null
          ? Scaffold(
              resizeToAvoidBottomInset: resizeToAvoidBottomInset,
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
                resizeToAvoidBottomInset: resizeToAvoidBottomInset,
                payload: payload,
                parent: this,
              ),
            ),
    );
  }

  PreferredSizeWidget? _buildAppBar(RenderPayload payload) {
    final child = childOf('appBar');

    if (child == null || child is! VWAppBar) return null;

    // Check AppBar visibility before building
    final isVisible = payload.evalExpr(child.props.visibility) ?? true;
    if (!isVisible) {
      return null;
    }

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

    // Check AppBar visibility before building
    final isVisible = appBarProps != null
        ? (payload.evalExpr(appBarProps.visibility) ?? true)
        : true;

    // Default enableOverlapAbsorption to true
    final enableOverlapAbsorption = true;

    Widget body;

    if (isVisible) {
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
        visibility: payload.eval(appBarProps?.visibility),
      );

      // Cache the header widget for performance
      final cachedHeaderWidget = VWSliverAppBar(
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
      ).toWidget(payload);

      body = NestedScrollView(
        headerSliverBuilder:
            (BuildContext innerContext, bool innerBoxIsScrolled) {
          Widget output = cachedHeaderWidget;

          if (enableOverlapAbsorption) {
            output = SliverOverlapAbsorber(
              handle:
                  NestedScrollView.sliverOverlapAbsorberHandleFor(innerContext),
              sliver: output,
            );
          }

          return <Widget>[output];
        },
        body: NestedScrollViewData(
          enableOverlapAbsorption: enableOverlapAbsorption,
          child: Builder(
            builder: (BuildContext context) {
              final updatedPayload = payload.copyWith(buildContext: context);
              return bodyWidget?.toWidget(updatedPayload) ?? empty();
            },
          ),
        ),
      );
    } else {
      // AppBar is not visible, just render the body without NestedScrollView
      body = bodyWidget?.toWidget(payload) ?? empty();
    }

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
  final bool resizeToAvoidBottomInset;

  const _ScaffoldWithBottomNav({
    required this.appBarWidget,
    required this.drawer,
    required this.endDrawer,
    required this.persistentFooterButtons,
    required this.isCollapsibleAppBar,
    required this.enableSafeArea,
    required this.payload,
    required this.parent,
    required this.resizeToAvoidBottomInset,
  });

  @override
  State<_ScaffoldWithBottomNav> createState() => _ScaffoldWithBottomNavState();
}

class _ScaffoldWithBottomNavState extends State<_ScaffoldWithBottomNav> {
  int _currentIndex = 0;

  late List<VirtualWidget> _navItems;
  final Map<int, Widget> _pageCache = {};

  // ------------------------------------------------------------
  // Lifecycle
  // ------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _navItems = _extractNavigationItems();
  }

  @override
  void didUpdateWidget(covariant _ScaffoldWithBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldNav = oldWidget.parent.childOf('bottomNavigationBar');
    final newNav = widget.parent.childOf('bottomNavigationBar');

    if (oldNav != newNav) {
      _navItems = _extractNavigationItems();
      _pageCache.clear();
      _currentIndex = 0;
    }
  }

  // ------------------------------------------------------------
  // Navigation extraction
  // ------------------------------------------------------------

  List<VirtualWidget> _extractNavigationItems() {
    final navBar = widget.parent.childOf('bottomNavigationBar');

    if (navBar is VWNavigationBar) {
      return navBar
              .childrenOf('children')
              ?.whereType<VWNavigationBarItemDefault>()
              .toList() ??
          [];
    }

    if (navBar is VWNavigationBarCustom) {
      return navBar
              .childrenOf('children')
              ?.whereType<VWNavigationBarItemCustom>()
              .toList() ??
          [];
    }

    return [];
  }

  // ------------------------------------------------------------
  // Preserve page flag
  // ------------------------------------------------------------

  bool _getPreservePageState() {
    final navBar = widget.parent.childOf('bottomNavigationBar');

    if (navBar is VWNavigationBar) {
      return navBar.props.rebuildOnEveryLoad
              ?.evaluate(widget.payload.scopeContext) ??
          false;
    }

    if (navBar is VWNavigationBarCustom) {
      return navBar.props.rebuildOnEveryLoad
              ?.evaluate(widget.payload.scopeContext) ??
          false;
    }

    return false;
  }

  // ------------------------------------------------------------
  // Page creation (lazy + cached)
  // ------------------------------------------------------------

  Widget _buildPage(int index) {
    if (_pageCache.containsKey(index)) {
      return _pageCache[index]!;
    }

    if (index >= _navItems.length) {
      return const SizedBox.shrink();
    }

    final item = _navItems[index];
    final onSelect = item is VWNavigationBarItemDefault
        ? item.props.onSelect
        : (item as VWNavigationBarItemCustom).props.onSelect;

    final entity = onSelect?['entity'] as JsonLike?;
    final entityId = as$<String?>(entity?['id']);
    final args = entity?['args'] as JsonLike?;

    final page = entityId != null
        ? DefaultActionExecutor.of(widget.payload.buildContext).viewBuilder(
            widget.payload.buildContext,
            entityId,
            args,
          )
        : const SizedBox.shrink();

    _pageCache[index] = page;
    return page;
  }

  // ------------------------------------------------------------
  // Action detection
  // ------------------------------------------------------------

  dynamic _getActionForIndex(int index) {
    if (index >= _navItems.length) return null;

    final item = _navItems[index];
    final onSelect = item is VWNavigationBarItemDefault
        ? item.props.onSelect
        : (item as VWNavigationBarItemCustom).props.onSelect;

    return (onSelect != null && onSelect['type'] == 'action')
        ? onSelect['action']
        : null;
  }

  // ------------------------------------------------------------
  // Bottom nav tap handler (ONLY place actions execute)
  // ------------------------------------------------------------

  void onDestinationSelected(int index) {
    final action = _getActionForIndex(index);

    if (action != null) {
      widget.payload.executeAction(
        ActionFlow.fromJson(action),
        triggerType: 'onPageSelected',
      );
      return;
    }

    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });
  }

  // ------------------------------------------------------------
  // Body builder (pure)
  // ------------------------------------------------------------

  Widget _buildBody() {
    final preserve = _getPreservePageState();

    if (preserve) {
      return IndexedStack(
        index: _currentIndex,
        children: List.generate(
          _navItems.length,
          (i) => _buildPage(i),
        ),
      );
    }

    return _buildPage(_currentIndex);
  }

  // ------------------------------------------------------------
  // Bottom Navigation Bar
  // ------------------------------------------------------------

  Widget? buildBottomNavigationBar(RenderPayload payload) {
    final navBar = widget.parent.childOf('bottomNavigationBar');

    if (navBar == null) return null;

    return Builder(builder: (context) {
      final updatedPayload = payload.copyWith(buildContext: context);

      if (navBar is VWNavigationBarCustom) {
        return VWNavigationBarCustom(
          props: navBar.props,
          commonProps: navBar.commonProps,
          parent: widget.parent,
          childGroups: navBar.childGroups,
          selectedIndex: _currentIndex,
          onDestinationSelected: onDestinationSelected,
        ).toWidget(updatedPayload);
      }

      if (navBar is VWNavigationBar) {
        return VWNavigationBar(
          props: navBar.props,
          commonProps: navBar.commonProps,
          parent: widget.parent,
          childGroups: navBar.childGroups,
          selectedIndex: _currentIndex,
          onDestinationSelected: onDestinationSelected,
        ).toWidget(updatedPayload);
      }

      return const SizedBox.shrink();
    });
  }

  // ------------------------------------------------------------
  // Build
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final body =
        widget.enableSafeArea ? SafeArea(child: _buildBody()) : _buildBody();

    return InheritedScaffoldController(
      currentIndex: _currentIndex,
      setCurrentIndex: onDestinationSelected,
      child: Scaffold(
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        appBar: widget.isCollapsibleAppBar
            ? null
            : widget.parent._buildAppBar(widget.payload),
        drawer: widget.drawer,
        endDrawer: widget.endDrawer,
        bottomNavigationBar: buildBottomNavigationBar(widget.payload),
        body: widget.isCollapsibleAppBar
            ? widget.parent._buildCollapsibleAppBarBody(
                widget.payload,
                widget.enableSafeArea,
              )
            : body,
        persistentFooterButtons: widget.persistentFooterButtons,
      ),
    );
  }
}
