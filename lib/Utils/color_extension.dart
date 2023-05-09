import 'package:flutter/material.dart';

extension ColorExtension on String {
  Color toColor() {
    if (!RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$').hasMatch(this)) {
      throw FormatException('Hexadecimal Color Value Is Invalid: $this');
    }
    if (startsWith('0xFF')) return Color(int.parse(this));
    var hexColor = '0xFF${substring(1)}';
    return Color(int.parse(hexColor));
  }
}
