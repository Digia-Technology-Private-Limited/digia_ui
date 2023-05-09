import 'dart:developer';

import 'package:digia_ui/Utils/color_extension.dart';
import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/Utils/dui_font.dart';
import 'package:flutter/material.dart';

class DUIConfigConstants {
  static const double fallbackSize = 14;
  static const String fallbackStyle = "";
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

TextAlign getTextAlign(String alignment) {
  switch (alignment) {
    case 'right':
      return TextAlign.right;
    case 'left':
      return TextAlign.left;
    case 'center':
      return TextAlign.center;
    case 'end':
      return TextAlign.end;
    case 'justify':
      return TextAlign.justify;
    default:
      return TextAlign.start;
  }
}

TextOverflow getTextOverFlow(String overFlow) {
  switch (overFlow) {
    case "fade":
      return TextOverflow.fade;
    case "visible":
      return TextOverflow.visible;
    case "clip":
      return TextOverflow.clip;
    default:
      return TextOverflow.ellipsis;
  }
}

TextDecoration? getTextDecoration(String decorationToken) {
  switch (decorationToken) {
    case "underline":
      return TextDecoration.underline;
    case "overline":
      return TextDecoration.overline;
    case "lineThrough":
      return TextDecoration.lineThrough;
    default:
      return TextDecoration.none;
  }
}

TextStyle? getTextStyle({required String style}) {
  Map<String, String>? styleItems = getStyleItems(style);
  if (styleItems != null) {
    if (styleItems.containsKey('f')) {
      DUIFont font = ConfigResolver().getFont(styleItems['f']!);
      TextStyle textStyle = TextStyle(
        fontWeight: getFontWeight(font.weight),
        fontStyle: getFontStyle(font.style),
        fontSize: font.size,
        height: font.height,
        color: styleItems.containsKey('tc')
            ? getTextColor(styleItems['tc']!)
            : null,
        decoration: styleItems.containsKey('dc')
            ? getTextDecoration(styleItems['dc']!)
            : getTextDecoration(DUIConfigConstants.fallbackStyle),
        wordSpacing: styleItems.containsKey('spc')
            ? getWordSpacing(styleItems['spc']!)
            : getWordSpacing(DUIConfigConstants.fallbackStyle),
      );
      return textStyle;
    }
  }
  return null;
}

double? getWordSpacing(String spacingToken) {
  return ConfigResolver().getSpacing(spacingToken);
}

Color? getTextColor(String colorToken) {
  String? colorValue = ConfigResolver().getColorValue(colorToken);
  try {
    return colorValue?.toColor();
  } on FormatException catch (_) {
    log("Invalid Color value in json");
  }
  return null;
}

Map<String, String>? getStyleItems(String style) {
  Map<String, String> resMap = {};
  if (style.isEmpty) return null;
  var styleItems = style.split(';');
  if (styleItems.isEmpty) return null;
  for (var i in styleItems) {
    List<String> styleItem = i.split(':');
    resMap[styleItem.first] = styleItem.last;
  }
  return resMap;
}
