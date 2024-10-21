import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../digia_ui.dart';
import '../components/DUIText/DUI_text_span/dui_text_span.dart';
import '../components/DUIText/dui_text_style.dart';
import '../components/utils/DUIBorder/dui_border.dart';
import '../core/evaluator.dart';
import '../framework/utils/functional_util.dart';
import 'basic_shared_utils/color_decoder.dart';
import 'basic_shared_utils/dui_decoder.dart';
import 'basic_shared_utils/lodash.dart';
import 'basic_shared_utils/num_decoder.dart';
import 'dui_font.dart';

class DUIConfigConstants {
  static const double fallbackSize = 14;
  static const String fallbackStyle = '';
  static const Color fallbackTextColor = Colors.black;
  static const double fallbackLineHeightFactor = 1.5;
  static const String fallbackBgColorHexCode = '#FFFFFF';
  static const String fallbackBorderColorHexCode = '#FF000000';
  static const Color fallbackBgColor = Colors.black;
}

DUIFont _mergeFontValues(
    DUIFont font, Map<String, dynamic>? fontAttributes, BuildContext context) {
  return DUIFont(
      weight: eval<String>(fontAttributes?['weight'], context: context) ??
          font.weight,
      size:
          eval<double>(fontAttributes?['size'], context: context) ?? font.size,
      height: eval<double>(fontAttributes?['height'], context: context) ??
          font.height,
      style: eval<String>(fontAttributes?['style'], context: context) ??
          font.style,
      fontFamily:
          as$<String>(fontAttributes?['fontFamily'] ?? font.fontFamily));
}

TextStyle? toTextStyle(DUITextStyle? textStyle, BuildContext context) {
  if (textStyle == null) return null;

  FontWeight fontWeight = FontWeight.normal;
  FontStyle fontStyle = FontStyle.normal;
  double? fontSize;
  double? fontHeight;
  String fontFamily = 'Poppins';

  if (textStyle.fontToken?.value != null) {
    final font = _mergeFontValues(
        DigiaUIClient.getConfigResolver().getFont(textStyle.fontToken!.value!),
        textStyle.fontToken!.font,
        context);

    fontWeight = DUIDecoder.toFontWeight(font.weight);
    fontFamily = font.fontFamily!;
    fontStyle = DUIDecoder.toFontStyle(font.style);
    fontSize = font.size ?? DUIConfigConstants.fallbackSize;
    fontHeight = font.height ?? DUIConfigConstants.fallbackLineHeightFactor;
  }

  Color? textColor =
      eval<String>(textStyle.textColor, context: context).letIfTrue(toColor);

  Color? textBgColor = textStyle.textBgColor.letIfTrue(toColor);

  TextDecoration? textDecoration =
      DUIDecoder.toTextDecoration(textStyle.textDecoration);
  Color? decorationColor = textStyle.textDecorationColor.letIfTrue(toColor);
  TextDecorationStyle? decorationStyle =
      DUIDecoder.toTextDecorationStyle(textStyle.textDecorationStyle);

  return GoogleFonts.getFont(fontFamily,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
      height: fontHeight,
      color: textColor,
      backgroundColor: textBgColor,
      decoration: textDecoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle);
}

TextSpan toTextSpan(DUITextSpan textSpan, BuildContext context) {
  return TextSpan(
    text: textSpan.text.toString(),
    style: toTextStyle(textSpan.spanStyle, context),
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

OutlinedBorder? toButtonShape(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is String) {
    return switch (value) {
      'stadium' => const StadiumBorder(),
      'circle' => const CircleBorder(),
      'none' => null,
      'roundedRect' || _ => const RoundedRectangleBorder()
    };
  }

  if (value is! Map) {
    try {
      return toButtonShape(value.toJson());
    } catch (err) {
      return null;
    }
  }

  final shape = value['value'] as String?;
  final borderColor = (value['borderColor'] as String?).letIfTrue(toColor) ??
      Colors.transparent;
  final borderWidth =
      NumDecoder.toDoubleOrDefault(value['borderWidth'], defaultValue: 1.0);
  final borderStyle =
      (value['borderStyle'] == 'solid') ? BorderStyle.solid : BorderStyle.none;
  final side =
      BorderSide(color: borderColor, width: borderWidth, style: borderStyle);

  return switch (shape) {
    'stadium' => StadiumBorder(side: side),
    'circle' => CircleBorder(
        eccentricity: NumDecoder.toDoubleOrDefault(value['eccentricity'],
            defaultValue: 0.0),
        side: side),
    'roundedRect' || _ => RoundedRectangleBorder(
        borderRadius: DUIDecoder.toBorderRadius(value['borderRadius']),
        side: side)
  };
}

Border? toBorder(DUIBorder? border, BuildContext context) {
  if (border == null || border.borderStyle != 'solid') {
    return null;
  }

  return Border.all(
    style: BorderStyle.solid,
    width: border.borderWidth ?? 1.0,
    color: makeColor(eval<String>(border.borderColor, context: context)) ??
        toColor(DUIConfigConstants.fallbackBorderColorHexCode),
  );
}

BorderSide toBorderSide(DUIBorder? borderSide) {
  if (borderSide == null || borderSide.borderStyle != 'solid') {
    return BorderSide.none;
  }

  return BorderSide(
      style: BorderStyle.solid,
      width: borderSide.borderWidth ?? 1.0,
      color: toColor(borderSide.borderColor ??
          DUIConfigConstants.fallbackBorderColorHexCode));
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
@Deprecated('Use makeColor instead')
Color toColor(String colorToken) {
  var colorString =
      DigiaUIClient.getConfigResolver().getColorValue(colorToken) ?? colorToken;

  final color = ColorDecoder.fromString(colorString);
  if (color == null) {
    throw FormatException('Invalid color Format: $colorString');
  }

  return color;
}

Gradient? toGradient(Map<String, Object?>? data, BuildContext context) {
  if (data == null) return null;

  final type = data['type'] as String?;

  switch (type) {
    case 'linear':
      final colors = (data['colorList'] as List?)
          ?.map((e) =>
              makeColor(
                  eval<String>(e['color'] as String?, context: context)) ??
              Colors.transparent)
          .nonNulls
          .toList();

      if (colors == null || colors.isEmpty) return null;

      final stops = (data['colorList'] as List?)
          ?.map((e) => NumDecoder.toDouble(e['stop']))
          .nonNulls
          .toList();

      final rotationInRadians = NumDecoder.toInt(data['angle'])
          .let((p0) => GradientRotation(p0 / 180.0 * math.pi));

      return LinearGradient(
          colors: colors,
          stops: stops?.length == colors.length ? stops! : null,
          transform: rotationInRadians);

    default:
      return null;
  }
}

Color? makeColor(dynamic color) {
  if (color == null) return null;

  if (color is Color) return color;

  if (color is! String) return null;

  return ColorDecoder.fromString(color);
}
