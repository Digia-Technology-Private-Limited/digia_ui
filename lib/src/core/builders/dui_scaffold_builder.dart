import 'package:flutter/material.dart';
import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../../components/bottom_nav_bar/bottom_nav_bar.dart';
import '../../components/bottom_nav_bar/bottom_nav_bar_props.dart';
import '../../components/floating_action_button/floating_action_button.dart';
import '../../components/floating_action_button/floating_action_button_props.dart';
import '../json_widget_builder.dart';
import 'dui_app_bar_builder.dart';
import 'dui_drawer_builder.dart';

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
          setState(() {
            bottomNavBarIndex = index;
          });
        }

        final appBar = (data.children['appBar']?.firstOrNull).let((root) {
          if (root.type != 'fw/appBar') {
            return null;
          }
          return DUIAppBarBuilder(data: root).build(context)
              as PreferredSizeWidget;
        });
        final drawer = (data.children['drawer']?.firstOrNull).let((root) {
          if (root.type != 'fw/drawer') {
            return null;
          }
          return DUIDrawerBuilder.create(root).build(context);
        });
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
        final floatingActionButtonProps =
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
            scaffoldBackgroundColor:
                (data.props['scaffoldBackgroundColor'] as String?)
                    .let(toColor));
        return Theme(
            data: themeData,
            child: bottomNavigationBar == null
                ? Scaffold(
                    appBar: appBar,
                    drawer: drawer,
                    body: data.children['body']?.firstOrNull.let((p0) {
                      return SafeArea(child: DUIWidget(data: p0));
                    }),
                    persistentFooterButtons: persistentFooterButtons,
                    floatingActionButton: floatingActionButton,
                    floatingActionButtonLocation:
                        DUIFloatingActionButtonLocation.fabLocation(
                            floatingActionButtonProps),
                  )
                : Scaffold(
                    appBar: appBar,
                    drawer: drawer,
                    bottomNavigationBar: bottomNavigationBar,
                    body: SafeArea(
                      child: DUIPage(
                        key: pageKey,
                        pageUid: List.generate(
                            data.children['bottomNavigationBar']![0]
                                .children['children']!.length,
                            (index) => data
                                .children['bottomNavigationBar']![0]
                                .children['children']![index]
                                .props['pageId'])[bottomNavBarIndex],
                      ),
                    ),
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
