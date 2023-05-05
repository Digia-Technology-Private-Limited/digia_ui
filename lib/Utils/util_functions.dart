import 'package:digia_ui/Utils/dui_font.dart';
import 'package:flutter/material.dart';

class DUIConfigConstants {
  static double fallbackSize = 14;
}

FontWeight getFontWeight(String? weight) {
  switch (weight) {
    case 'thin':
      return FontWeight.w100;
    case 'extra-light':
      return FontWeight.w200;
    case 'light':
      return FontWeight.w300;
    case 'regular':
      return FontWeight.normal;
    case 'medium':
      return FontWeight.w500;
    case 'semi-bold':
      return FontWeight.w600;
    case 'bold':
      return FontWeight.w700;
    case 'extra-bold':
      return FontWeight.w800;
    case 'thick':
      return FontWeight.w900;
  }

  return FontWeight.normal;
}

FontStyle getFontStyle(String? style) {
  switch (style) {
    case 'italic':
      return FontStyle.italic;
  }

  return FontStyle.normal;
}

TextStyle getTextStyle(DUIFont fontModel) {
  var fontSize = fontModel.size;
  var lineHeight = fontModel.height;
  var fontWeight = getFontWeight(fontModel.weight);
  var fontStyle = getFontStyle(fontModel.style);

  var style = TextStyle(
      fontSize: fontSize,
      height: lineHeight,
      fontWeight: fontWeight,
      fontStyle: fontStyle);

  return style;
}
