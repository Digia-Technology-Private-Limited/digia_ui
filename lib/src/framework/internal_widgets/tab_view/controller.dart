import 'package:flutter/material.dart';

class TabViewController extends TabController {
  final List<Object?> tabs;

  TabViewController({
    required this.tabs,
    required super.vsync,
    super.animationDuration,
    super.initialIndex,
  }) : super(length: tabs.length);
}
