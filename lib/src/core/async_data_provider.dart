import 'package:flutter/material.dart';

import 'json_widget_builder.dart';

class AsyncDataProvider extends InheritedWidget {
  final Object? data;

  AsyncDataProvider(
      {super.key, required this.data, required DUIWidgetBuilder builder})
      : super(child: Builder(builder: builder.build));

  static AsyncDataProvider? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AsyncDataProvider>();

  @override
  bool updateShouldNotify(covariant AsyncDataProvider oldWidget) => false;
}
