import 'package:digia_ui/Utils/color_extension.dart';
import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/Utils/dui_font.dart';
import 'package:flutter/material.dart';

class DUIConfigConstants {
  static const double fallbackSize = 14;
  static const String fallbackStyle = "f:para1;tc:text;dc:underline;spc:sp-100";
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

TextStyle getTextStyleHelper(DUIFont fontModel) {
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

TextOverflow getOverFlow(String overFlow) {
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

TextDecoration? getTextDecoration(
    {String? style = DUIConfigConstants.fallbackStyle}) {
  if (style!.isEmpty) return null;
  var styleItems = style.split(';').where((e) => e.startsWith('dc:')).toList();
  if (styleItems.isEmpty) return null;
  var styleItem = styleItems.first;
  var decorationToken = styleItem.split(':').last;
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

TextStyle? getTextStyle({String? style = DUIConfigConstants.fallbackStyle}) {
  //todo will check why DUIConfigConstants.fallbackStyle is not working
  if ((style ?? '').isEmpty) return null;
  var styleItems = style!.split(';').where((e) => e.startsWith('f:')).toList();
  if (styleItems.isEmpty) return null;
  var styleItem = styleItems.first;
  var fontToken = styleItem.split(':').last;
  DUIFont font = ConfigResolver().getFont(fontToken);
  TextStyle fromFont = getTextStyleHelper(font);
  var res = fromFont.copyWith(
      color: getTextColor(style: style) ?? Colors.black,
      decoration: getTextDecoration(style: style),
      wordSpacing: getWordSpacing(style: style));
  print(res);
  return res;
}

double? getWordSpacing({String? style = DUIConfigConstants.fallbackStyle}) {
  if (style!.isEmpty) return null;
  var styleItems = style.split(';').where((e) => e.startsWith('spc:')).toList();
  if (styleItems.isEmpty) return null;
  var styleItem = styleItems.first;
  var spacingToken = styleItem.split(':').last;
  return ConfigResolver().getSpacing(spacingToken);
}

Color? getTextColor({String? style = DUIConfigConstants.fallbackStyle}) {
  if (style!.isEmpty) return null;
  var styleItems = style.split(';').where((e) => e.startsWith('tc:')).toList();
  if (styleItems.isEmpty) return null;
  var styleItem = styleItems.first;
  var colorToken = styleItem.split(':').last;
  String? colorValue = ConfigResolver().getColorValue(colorToken);
  return colorValue?.toColor();
}
