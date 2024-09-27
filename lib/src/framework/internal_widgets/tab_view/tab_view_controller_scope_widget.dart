import 'package:flutter/widgets.dart';

import 'controller.dart';
import 'tab_view_controller_provider.dart';

class TabViewControllerScopeWidget extends StatefulWidget {
  final List<Object?> tabs;
  final int initialIndex;
  final Widget child;

  const TabViewControllerScopeWidget({
    super.key,
    required this.tabs,
    required this.child,
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
    return TabViewControllerProvider(
      tabController: _tabController,
      child: widget.child,
    );
  }
}
