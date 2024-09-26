import 'package:flutter/material.dart';

import '../base/extensions.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';
import 'app_bar.dart';
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

  // void onDestinationSelected(int index, RenderPayload payload) {
  //   final actionValue = props
  //       .getList('bottomNavigationBar.children')?[index]
  //       .getString('onPageSelected');

  //   final onClick = ActionFlow.fromJson(actionValue);
  //   ActionHandler.instance
  //       .execute(context: payload.buildContext, actionFlow: onClick);
  // }

  @override
  Widget render(RenderPayload payload) {
    final appBar = _buildAppBar(payload);
    final drawer = childOf('drawer')?.toWidget(payload);
    final endDrawer = childOf('endDrawer')?.toWidget(payload);
    final persistentFooterButtons =
        childrenOf('persistentFooterButtons')?.toWidgetArray(payload);
    const bottomNavigationBar = null;

    // final pageKey = UniqueKey();
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
          : Scaffold(
              appBar: appBar,
              drawer: drawer,
              endDrawer: endDrawer,
              // bottomNavigationBar: bottomNavigationBar,
              // body: _buildBodyWithNavBar(payload, pageKey, enableSafeArea),
              persistentFooterButtons: persistentFooterButtons,
            ),
    );
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
    if (child == null || child is! VirtualLeafStatelessWidget<Props>) {
      return null;
    }

    return child.props.getMap('drawerIcon').maybe((p0) {
      return VWIcon(props: Props(p0), commonProps: null, parent: null);
    });
  }

  VirtualWidget? _endDrawerIcon() {
    final child = childOf('endDrawer');
    if (child == null || child is! VirtualLeafStatelessWidget<Props>) {
      return null;
    }

    return child.props.getMap('drawerIcon').maybe((p0) {
      return VWIcon(props: Props(p0), commonProps: null, parent: null);
    });
  }
}
