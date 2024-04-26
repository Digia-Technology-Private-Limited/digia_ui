import 'package:flutter/material.dart';

import '../types.dart';

class DUIWidgetScope extends InheritedWidget {
  final DUIIconDataProvider? iconDataProvider;
  final DUIImageProviderFn? imageProviderFn;
  final DUITextStyleBuilder? textStyleBuilder;
  final DUIExternalFunctionHandler? externalFunctionHandler;

  const DUIWidgetScope({
    super.key,
    this.iconDataProvider,
    this.imageProviderFn,
    this.textStyleBuilder,
    this.externalFunctionHandler,
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
