import 'package:flutter/material.dart';
import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../ui_factory.dart';
import '../utils/functional_util.dart';
import '../widget_props/icon_props.dart';
import 'app_bar.dart';
import 'bottom_navigation_bar.dart';
import 'bottom_navigation_bar_item.dart';
import 'drawer.dart';
import 'icon.dart';
import 'safe_area.dart';

class VWScaffold extends VirtualStatelessWidget<Props> {
  VWScaffold({
    required super.props,
    required super.commonProps,
    required super.parent,
    required super.childGroups,
    super.refName,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    final appBar = _buildAppBar(payload);
    final drawer = childOf('drawer')?.toWidget(payload);
    final endDrawer = childOf('endDrawer')?.toWidget(payload);
    final persistentFooterButtons =
        childrenOf('persistentFooterButtons')?.toWidgetArray(payload);
    final bottomNavigationBar =
        childOf('bottomNavigationBar')?.toWidget(payload);

    int bottomNavBarIndex = 0;
    final themeData = Theme.of(payload.buildContext).copyWith(
      dividerTheme: const DividerThemeData(color: Colors.transparent),
      scaffoldBackgroundColor:
          payload.evalColor(props.get('scaffoldBackgroundColor')),
    );
    final enableSafeArea =
        payload.eval<bool>(props.get('enableSafeArea')) ?? true;

    return Theme(
        data: themeData,
        child: bottomNavigationBar == null
            ? Scaffold(
                appBar: appBar,
                drawer: drawer,
                endDrawer: endDrawer,
                persistentFooterButtons: persistentFooterButtons,
                body: childOf('body').maybe((p0) {
                  if (enableSafeArea == false) return p0.toWidget(payload);

                  return VWSafeArea.withChild(p0).toWidget(payload);
                }),
              )
            : StatefulBuilder(
                builder: (context, setState) {
                  void onDestinationSelected(int index) {
                    setState(() {
                      bottomNavBarIndex = index;
                    });
                  }

                  Widget? buildBottomNavigationBar(RenderPayload payload) {
                    final child = childOf('bottomNavigationBar');
                    if (child == null || child is! VWBottomNavigationBar) {
                      return null;
                    }

                    return VWBottomNavigationBar(
                      props: child.props,
                      commonProps: child.commonProps,
                      parent: this,
                      childGroups: child.childGroups,
                      onDestinationSelected: (p0) {
                        onDestinationSelected(p0);
                      },
                    ).toWidget(payload);
                  }

                  return Scaffold(
                    appBar: appBar,
                    drawer: drawer,
                    endDrawer: endDrawer,
                    bottomNavigationBar: buildBottomNavigationBar(payload),
                    body: _buildBodyWithNavBar(
                        payload, bottomNavBarIndex, enableSafeArea),
                    persistentFooterButtons: persistentFooterButtons,
                  );
                },
              ));
  }

  PreferredSizeWidget? _buildAppBar(RenderPayload payload) {
    final child = childOf('appBar');

    if (child == null || child is! VWAppBar) return null;

    return VWAppBar(
            props: child.props,
            parent: this,
            leadingIcon: _drawerIcon(),
            trailingIcon: _endDrawerIcon())
        .toWidget(payload) as PreferredSizeWidget;
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
    if (bottomNavBar is! VWBottomNavigationBar) return null;

    final navigationItems =
        bottomNavBar.children?.whereType<VWBottomNavigationBarItem>().toList();
    if (navigationItems == null || navigationItems.isEmpty) return null;

    final entityIds = navigationItems
        .map((item) => item.props?.getMap('entity')?['id'])
        .toList();
    if (entityIds.isEmpty || bottomNavBarIndex >= entityIds.length) return null;

    final currentEntityId = entityIds[bottomNavBarIndex];
    if (currentEntityId == null) return null;

    final currentEntityArgs = navigationItems
        .firstWhere(
            (item) => item.props?.getMap('entity')?['id'] == currentEntityId)
        .props
        ?.getMap('entity')?['args'];

    final Widget? entity;
    if (DUIFactory().configProvider.isPage(currentEntityId)) {
      entity = DUIFactory().createPage(currentEntityId, currentEntityArgs);
    } else {
      entity = DUIFactory().createComponent(currentEntityId, currentEntityArgs);
    }

    return enableSafeArea ? SafeArea(child: entity) : entity;
  }
}
