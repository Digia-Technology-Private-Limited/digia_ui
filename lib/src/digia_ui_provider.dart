import 'package:digia_ui/src/digia_ui_service.dart';
import 'package:flutter/material.dart';

class DigiaUIProvider extends InheritedWidget {
  final DigiaUIService service;

  const DigiaUIProvider(
      {super.key, required super.child, required this.service});

  static DigiaUIProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DigiaUIProvider>();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
