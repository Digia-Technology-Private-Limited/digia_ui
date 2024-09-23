import 'package:flutter/material.dart';

class DUIPageRoute<T> extends MaterialPageRoute<T> {
  DUIPageRoute({
    required String pageId,
    required super.builder,
  }) : super(
          settings: RouteSettings(name: '/duiPageRoute-$pageId'),
        );
}
