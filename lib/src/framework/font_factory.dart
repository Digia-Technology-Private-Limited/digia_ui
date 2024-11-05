import 'package:flutter/widgets.dart';

abstract class DUIFontFactory {
  TextStyle getFont(
    String fontFamily, {
    TextStyle? textStyle,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  });

  TextStyle getDefaultFont();
}
