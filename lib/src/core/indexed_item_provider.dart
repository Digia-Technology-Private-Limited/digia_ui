import 'package:flutter/material.dart';

import 'json_widget_builder.dart';

class IndexedItemWidgetBuilder extends InheritedWidget {
  final int index;
  final Object? currentItem;

  IndexedItemWidgetBuilder(
      {super.key,
      required this.index,
      required this.currentItem,
      required DUIWidgetBuilder builder})
      : super(child: Builder(builder: builder.build));

  static IndexedItemWidgetBuilder? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<IndexedItemWidgetBuilder>();

  @override
  bool updateShouldNotify(covariant IndexedItemWidgetBuilder oldWidget) =>
      false;
}
