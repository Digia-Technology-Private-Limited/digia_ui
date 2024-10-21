import 'package:flutter/material.dart';
import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../../components/bottom_nav_bar/bottom_nav_bar.dart';
import '../../components/bottom_nav_bar/bottom_nav_bar_props.dart';
import '../../components/dui_widget_creator_fn.dart';
import '../../components/floating_action_button/floating_action_button.dart';
import '../../components/floating_action_button/floating_action_button_props.dart';
import '../action/action_handler.dart';
import '../action/action_prop.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import 'dui_app_bar_builder.dart';
import 'dui_drawer_builder.dart';
import 'dui_icon_builder.dart';

class DUIScaffoldBuilder extends DUIWidgetBuilder {
  final DUIFloatingActionButtonProps? duiFloatingActionButtonProps;
  DUIScaffoldBuilder({this.duiFloatingActionButtonProps, required super.data});
  static DUIScaffoldBuilder create(DUIWidgetJsonData data) {
    return DUIScaffoldBuilder(data: data);
  }

  int bottomNavBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (cntxt, setState) {
        void onDestinationSelected(int index) {
          final actionValue = data.children['bottomNavigationBar']?.first
              .children['children']?[index].props['onPageSelected'];
          final onClick = ActionFlow.fromJson(actionValue);
          ActionHandler.instance.execute(context: context, actionFlow: onClick);
          setState(() {
            bottomNavBarIndex = index;
          });
        }

        final appBar = (data.children['appBar']?.firstOrNull).let((root) {
          if (root.type != 'fw/appBar') {
            return null;
          }

          // leading and trailing
          Widget? leadingIcon() {
            final iconBuilder = DUIIconBuilder.fromProps(
                props:
                    data.children['drawer']?.firstOrNull?.props['drawerIcon']);
            return ifNotNull(
                iconBuilder,
                (p0) => DUIGestureDetector(
                    context: context,
                    actionFlow: ActionFlow(actions: [
                      ActionProp.fromJson({
                        'type': 'Action.controlDrawer',
                        'data': {'choice': 'openDrawer'}
                      })
                    ]),
                    child: p0.build(context)));
          }

          Widget? trailingIcon() {
            final iconBuilder = DUIIconBuilder.fromProps(
                props: data
                    .children['endDrawer']?.firstOrNull?.props['drawerIcon']);
            return ifNotNull(
                iconBuilder,
                (p0) => DUIGestureDetector(
                    context: context,
                    actionFlow: ActionFlow(actions: [
                      ActionProp.fromJson({
                        'type': 'Action.controlDrawer',
                        'data': {'choice': 'openEndDrawer'}
                      })
                    ]),
                    child: p0.build(context)));
          }

          return DUIAppBarBuilder.create(root,
                  leadingIcon: leadingIcon(), trailingIcon: trailingIcon())
              ?.build(context) as PreferredSizeWidget;
        });
        final drawer = ifNotNull(data.children['drawer']?.firstOrNull,
            (p0) => DUIDrawerBuilder(p0, registry));

        final endDrawer = ifNotNull(data.children['endDrawer']?.firstOrNull,
            (p0) => DUIDrawerBuilder(p0, registry));

        final persistentFooterButtons =
            (data.children['persistentFooterButtons']).let((child) {
          return child.map((e) => DUIWidget(data: e)).toList();
        });
        final floatingActionButton =
            (data.children['floatingActionButton']?.firstOrNull).let((root) {
          if (root.type != 'digia/floatingActionButton') {
            return null;
          }
          return DUIFloatingActionButton.floatingActionButton(
              root.props, context, data);
        });
        final DUIFloatingActionButtonProps? floatingActionButtonProps =
            (data.children['floatingActionButton']?.firstOrNull).let((root) {
          if (root.type != 'digia/floatingActionButton') {
            return null;
          }
        });
        final bottomNavigationBar =
            (data.children['bottomNavigationBar']?.firstOrNull).let((root) {
          if (root.type != 'digia/navigationBar') {
            return null;
          }
          return DUIBottomNavigationBar(
            children: root.children['children']!,
            barProps: DUIBottomNavigationBarProps.fromJson(root.props),
            onDestinationSelected: (index) {
              onDestinationSelected(index);
            },
          );
        });
        // Key for DUIPage widget
        final pageKey = UniqueKey();
        final themeData = Theme.of(context).copyWith(
            dividerTheme: const DividerThemeData(color: Colors.transparent),
            scaffoldBackgroundColor: makeColor(eval<String>(
                data.props['scaffoldBackgroundColor'],
                context: context)));
        final enableSafeArea =
            eval<bool>(data.props['enableSafeArea'], context: context);
        return Theme(
            data: themeData,
            child: bottomNavigationBar == null
                ? Scaffold(
                    appBar: appBar,
                    drawer: drawer?.build(context),
                    endDrawer: endDrawer?.build(context),
                    body: data.children['body']?.firstOrNull.let((p0) {
                      final child = DUIWidget(data: p0);
                      // Explicit check on false for backward compatibility
                      if (enableSafeArea == false) return child;

                      return SafeArea(child: child);
                    }),
                    persistentFooterButtons: persistentFooterButtons,
                    floatingActionButton: floatingActionButton,
                    floatingActionButtonLocation:
                        DUIFloatingActionButtonLocation.fabLocation(
                            floatingActionButtonProps),
                  )
                : Scaffold(
                    appBar: appBar,
                    drawer: drawer?.build(context),
                    endDrawer: endDrawer?.build(context),
                    bottomNavigationBar: bottomNavigationBar,
                    body: () {
                      final widget = DUIPage(
                        key: pageKey,
                        pageUid: List.generate(
                            data.children['bottomNavigationBar']![0]
                                .children['children']!.length,
                            (index) => data
                                .children['bottomNavigationBar']![0]
                                .children['children']![index]
                                .props['pageId'])[bottomNavBarIndex] as String,
                      );
                      if (enableSafeArea == false) return widget;

                      return SafeArea(child: widget);
                    }(),
                    persistentFooterButtons: persistentFooterButtons,
                    floatingActionButton: floatingActionButton,
                    floatingActionButtonLocation:
                        DUIFloatingActionButtonLocation.fabLocation(
                            floatingActionButtonProps),
                  ));
      },
    );
  }
}
