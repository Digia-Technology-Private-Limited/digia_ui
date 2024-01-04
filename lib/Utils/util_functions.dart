import 'package:digia_ui/Utils/basic_shared_utils/color_decoder.dart';
import 'package:digia_ui/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/components/DUIText/DUI_text_span/dui_text_span.dart';
import 'package:digia_ui/components/DUIText/dui_text_style.dart';
import 'package:digia_ui/components/utils/DUIBorder/dui_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DUIConfigConstants {
  static const double fallbackSize = 14;
  static const String fallbackStyle = '';
  static const Color fallbackTextColor = Colors.black;
  static const double fallbackLineHeightFactor = 1.5;
  static const String fallbackBgColorHexCode = '#FFFFFF';
  static const String fallbackBorderColorHexCode = '#FF000000';
}

TextStyle? toTextStyle(DUITextStyle? textStyle) {
  if (textStyle == null) return null;

  FontWeight fontWeight = FontWeight.normal;
  FontStyle fontStyle = FontStyle.normal;
  double fontSize = DUIConfigConstants.fallbackSize;
  double fontHeight = DUIConfigConstants.fallbackLineHeightFactor;

  if (textStyle.fontToken != null) {
    var font = ConfigResolver().getFont(textStyle.fontToken!);
    fontWeight = DUIDecoder.toFontWeight(font.weight);
    fontStyle = DUIDecoder.toFontStyle(font.style);
    fontSize = font.size ?? DUIConfigConstants.fallbackSize;
    fontHeight = font.height ?? DUIConfigConstants.fallbackLineHeightFactor;
  }

  Color textColor = textStyle.textColor.letIfTrue(toColor) ??
      DUIConfigConstants.fallbackTextColor;

  Color? textBgColor = textStyle.textBgColor.letIfTrue(toColor);

  TextDecoration textDecoration =
      DUIDecoder.toTextDecoration(textStyle.textDecoration);
  Color? decorationColor = textStyle.textDecorationColor.letIfTrue(toColor);
  TextDecorationStyle? decorationStyle =
      DUIDecoder.toTextDecorationStyle(textStyle.textDecorationStyle);
  String fontFamily = textStyle.fontFamily ??
      'Poppins'; // TODO: This shouldn't be hardcoded here.

  debugPrint('[fontFamily] : ${textStyle.fontFamily}');

  return GoogleFonts.getFont(fontFamily).copyWith(
    // fontFamily: fontFamily,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    fontSize: fontSize,
    height: fontHeight,
    color: textColor,
    backgroundColor: textBgColor,
    decoration: textDecoration,
    decorationColor: decorationColor,
    decorationStyle: decorationStyle,
  );
}

TextSpan toTextSpan(DUITextSpan textSpan) {
  return TextSpan(
    text: textSpan.text,
    style: toTextStyle(textSpan.spanStyle),
    // recognizer: TapGestureRecognizer()
    //   ..onTap = () async {
    //     //todo change onTap functionality according to backend latter
    //     if (url != null) {
    //       if (await canLaunchUrl(Uri.parse(url!))) {
    //         await launchUrl(Uri.parse(url!));
    //       } else {
    //         null;
    //       }
    //     } else {
    //       null;
    //     }
    //   },
  );
}

Map<String, String> createStyleMap(String? styleClass) {
  if (styleClass == null) return {};

  if (styleClass.isEmpty) return {};

  final styleItems = styleClass.split(';');
  if (styleItems.isEmpty) return {};

  return styleItems.fold({}, (previousValue, element) {
    List<String> splitValues = element.split(':');
    previousValue[splitValues.first.trim()] = splitValues.last.trim();
    return previousValue;
  });
}

Border? toBorder(DUIBorder? border) {
  if (border == null || border.borderStyle != 'solid') {
    return null;
  }

  return Border.all(
      style: BorderStyle.solid,
      width: border.borderWidth ?? 1.0,
      color: toColor(
          border.borderColor ?? DUIConfigConstants.fallbackBorderColorHexCode));
}

OutlineInputBorder? toOutlineInputBorder(DUIBorder? border) {
  if (border == null) {
    return null;
  }

  return OutlineInputBorder(
      borderRadius: DUIDecoder.toBorderRadius(border.borderRadius?.toJson()),
      borderSide: BorderSide(
          color: toColor(border.borderColor ??
              DUIConfigConstants.fallbackBorderColorHexCode),
          width: border.borderWidth ?? 1.0));
}

// Possible Values for colorToken:
// token: primary, hexCode: #242424, hexCode with Alpha: #FF242424
Color toColor(String colorToken) {
  var colorString = ConfigResolver().getColorValue(colorToken) ?? colorToken;

  final color = ColorDecoder.fromString(colorString);
  if (color == null) {
    throw FormatException('Invalid color Format: $colorString');
  }

  return color;
}
