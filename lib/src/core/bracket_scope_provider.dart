import 'package:flutter/widgets.dart';

import 'json_widget_builder.dart';

class BracketScope extends InheritedWidget {
  final List<(String varName, Object? value)> variables;

  BracketScope(
      {super.key, required this.variables, required DUIWidgetBuilder builder})
      : super(child: Builder(builder: builder.build));

  static BracketScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BracketScope>();

  @override
  bool updateShouldNotify(covariant BracketScope oldWidget) => false;
}
