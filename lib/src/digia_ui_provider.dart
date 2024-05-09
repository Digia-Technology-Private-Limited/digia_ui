import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/digia_ui_service.dart';
import 'package:flutter/material.dart';

class DigiaUIProvider extends InheritedWidget {
  late final DigiaUIService service;

  DigiaUIProvider({super.key, required super.child, DigiaUIService? service}) {
    this.service = service ?? DigiaUIClient.createService();
  }

  static DigiaUIProvider? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<DigiaUIProvider>();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
