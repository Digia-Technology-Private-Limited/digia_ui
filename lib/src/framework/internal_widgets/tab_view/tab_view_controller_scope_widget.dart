import 'package:flutter/widgets.dart';
import 'controller.dart';
import 'inherited_tab_view_controller.dart';

class TabViewControllerScopeWidget extends StatefulWidget {
  final List<Object?> tabs;
  final int initialIndex;
  final WidgetBuilder childBuilder;
  final Function(int currentIndex)? onTabChange;

  const TabViewControllerScopeWidget({
    super.key,
    required this.tabs,
    this.onTabChange,
    required this.childBuilder,
    this.initialIndex = 0,
  });

  @override
  _TabViewControllerScopeWidgetState createState() =>
      _TabViewControllerScopeWidgetState();
}

class _TabViewControllerScopeWidgetState
    extends State<TabViewControllerScopeWidget>
    with SingleTickerProviderStateMixin {
  late TabViewController _tabController;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
    _tabController.addListener(
      () {
        if (_tabController.indexIsChanging) {
          widget.onTabChange?.call(_tabController.index);
        }
      },
    );
  }

  void _initializeTabController() {
    _tabController = TabViewController(
      tabs: widget.tabs,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedTabViewController(
      tabController: _tabController,
      // This is important, to insert a layer of BuildContext in between inheritedwidget and its child.
      child: Builder(builder: (innerCtx) => widget.childBuilder(innerCtx)),
    );
  }
}
