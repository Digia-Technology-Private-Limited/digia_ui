import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bottom_navbar.props.g.dart';

@JsonSerializable()
class DUIBottomNavbarProps {
  late List<Map<String, dynamic>> items;
  late String type;
  int currentIndex = 0;
  late List<Widget> screens = [
    const Center(
      child: Text('home'),
    ),
    const Center(
      child: Text('school'),
    ),
    const Center(
      child: Text('bookmark'),
    ),
  ];
  VoidCallback? onTap;
  DUIBottomNavbarProps();

  factory DUIBottomNavbarProps.fromJson(Map<String, dynamic> json) =>
      _$DUIBottomNavbarPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIBottomNavbarPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  DUIBottomNavbarProps mockWidget() {
    return DUIBottomNavbarProps.fromJson({
      'type': 'fixed',
      'items': [
        {
          'icon': '0xf7f5',
          'activeIcon': '0xf7f5',
          'label': '',
        },
        {
          'icon': '0xf33c',
          'activeIcon': '0xf012e',
          'label': '',
        },
        {
          'icon': '0xe0f4',
          'activeIcon': '0xeee3',
          'label': '',
        },
      ]
    });
  }
}
