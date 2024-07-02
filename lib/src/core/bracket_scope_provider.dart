import 'package:flutter/widgets.dart';

class BracketScope extends InheritedWidget {
  final List<(String varName, Object? value)> variables;

  BracketScope({super.key, required this.variables, required Widget builder})
      : super(child: Builder(builder: (context) => builder));

  static BracketScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BracketScope>();

  @override
  bool updateShouldNotify(covariant BracketScope oldWidget) => false;
}
