import 'package:flutter/material.dart';

import '../types.dart';

class DUIWidgetScope extends InheritedWidget {
  final DUIIconDataProvider? iconDataProvider;
  final DUIImageProviderFn? imageProviderFn;
  final DUITextStyleBuilder? textStyleBuilder;
  final DUIMessageHandler2? onMessageReceived;
  final GlobalKey<NavigatorState>? navigatorKey;

  const DUIWidgetScope({
    super.key,
    this.iconDataProvider,
    this.imageProviderFn,
    this.textStyleBuilder,
    this.onMessageReceived,
    this.navigatorKey,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant DUIWidgetScope oldWidget) {
    return false;
  }

  static DUIWidgetScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DUIWidgetScope>();
  }
}
