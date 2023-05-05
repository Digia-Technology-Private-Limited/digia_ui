import 'package:flutter/material.dart';

extension ColorExtension on String {
  Color toColor() {
    if (startsWith('0xFF')) return Color(int.parse(this));
    var hexColor = '0xFF${substring(1)}';
    return Color(int.parse(hexColor));
  }
}
