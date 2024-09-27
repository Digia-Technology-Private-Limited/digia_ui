import 'package:flutter/material.dart';

import 'controller.dart';

class TabViewControllerProvider extends InheritedWidget {
  final TabViewController tabController;

  const TabViewControllerProvider({
    super.key,
    required this.tabController,
    required super.child,
  });

  /// Retrieve the [TabViewController] from the context or return null if it doesn't exist
  static TabViewController? maybeOf(BuildContext context) {
    return context
        .getInheritedWidgetOfExactType<TabViewControllerProvider>()
        ?.tabController;
  }

  /// Retrieve the [TabViewController] from the context and throw an error if not found
  static TabViewController of(BuildContext context) {
    final tabController = maybeOf(context);
    assert(tabController != null, 'No InternalTabController found in context');
    return tabController!;
  }

  @override
  bool updateShouldNotify(covariant TabViewControllerProvider oldWidget) =>
      false;
}
