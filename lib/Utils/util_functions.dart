import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/components/DUIText/DUI_text_span/dui_text_span.dart';
import 'package:digia_ui/components/utils/DUICornerRadius/dui_corner_radius.dart';
import 'package:digia_ui/components/utils/DUIInsets/dui_insets.dart';
import 'package:flutter/material.dart';

class DUIConfigConstants {
  static const double fallbackSize = 14;
  static const String fallbackStyle = "";
  static const Color fallbackTextColor = Colors.black;
  static const double fallbackLineHeightFactor = 1.5;
}

FontWeight toFontWeight(String? weight) {
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
    case 'black':
      return FontWeight.w900;
  }

  return FontWeight.normal;
}

FontStyle toFontStyle(String? style) {
  switch (style) {
    case 'italic':
      return FontStyle.italic;
  }

  return FontStyle.normal;
}

TextAlign toTextAlign(String? alignment) {
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
  }
  return TextAlign.start;
}

TextOverflow toTextOverflow(String? overflow) {
  switch (overflow) {
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

TextDecoration toTextDecoration(String textDecorationToken) {
  switch (textDecorationToken) {
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

TextDecorationStyle? toTextDecorationStyle(String textDecorationStyleToken) {
  switch (textDecorationStyleToken) {
    case "dashed":
      return TextDecorationStyle.dashed;
    case "dotted":
      return TextDecorationStyle.dotted;
    case "double":
      return TextDecorationStyle.double;
    case "solid":
      return TextDecorationStyle.solid;
    case "wavy":
      return TextDecorationStyle.wavy;
  }

  return null;
}

TextStyle? toTextStyle({required String styleClass}) {
  var styleClassMap = _createStyleMap(styleClass);

  if (styleClassMap.isEmpty) {
    return null;
  }

  FontWeight fontWeight = FontWeight.normal;
  FontStyle fontStyle = FontStyle.normal;
  double fontSize = DUIConfigConstants.fallbackSize;
  double fontHeight = DUIConfigConstants.fallbackLineHeightFactor;
  Color textColor = DUIConfigConstants.fallbackTextColor;
  TextDecoration textDecoration = TextDecoration.none;
  Color? decorationColor;
  TextDecorationStyle? decorationStyle;

  styleClassMap.forEach((key, value) {
    switch (key) {
      // Font token
      case 'ft':
        var font = ConfigResolver().getFont(value);
        fontWeight = toFontWeight(font.weight);
        fontStyle = toFontStyle(font.style);
        fontSize = font.size ?? DUIConfigConstants.fallbackSize;
        fontHeight = font.height ?? DUIConfigConstants.fallbackLineHeightFactor;
        break;

      // Text Color
      case 'tc':
        textColor = toColor(value);
        break;

      // Text Decoration
      case 'd':
        textDecoration = toTextDecoration(value);
        break;

      // Text Deocration Color
      case 'dc':
        decorationColor = toColor(value);
        break;

      // Text Deocration Style
      case 'ds':
        decorationStyle = toTextDecorationStyle(value);
    }
  });

  return TextStyle(
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
      height: fontHeight,
      color: textColor,
      decoration: textDecoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle);
}

TextSpan toTextSpan(DUITextSpan textSpan) {
  return TextSpan(
    text: textSpan.text,
    style: toTextStyle(styleClass: textSpan.styleClass ?? ""),
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

BoxFit toBoxFit(String fitValue) {
  switch (fitValue) {
    case 'fill':
      return BoxFit.fill;
    case 'contain':
      return BoxFit.contain;
    case 'cover':
      return BoxFit.cover;
    case 'fitWidth':
      return BoxFit.fitWidth;
    case 'fitHeight':
      return BoxFit.fitHeight;
    case 'scaleDown':
      return BoxFit.scaleDown;
  }

  return BoxFit.none;
}

Map<String, String> _createStyleMap(String styleClass) {
  if (styleClass.isEmpty) return {};

  final styleItems = styleClass.split(';');
  if (styleItems.isEmpty) return {};

  return styleItems.fold({}, (previousValue, element) {
    List<String> splitValues = element.split(':');
    previousValue[splitValues.first] = splitValues.last;
    return previousValue;
  });
}

BorderRadiusGeometry toBorderRadiusGeometry(DUICornerRadius? cornerRadius) {
  return BorderRadius.only(
    topLeft: Radius.circular(cornerRadius?.topLeft ?? 0.0),
    topRight: Radius.circular(cornerRadius?.topRight ?? 0.0),
    bottomLeft: Radius.circular(cornerRadius?.bottomLeft ?? 0.0),
    bottomRight: Radius.circular(cornerRadius?.bottomRight ?? 0.0),
  );
}

// Possible Values for colorToken:
// token: primary, hexCode: #242424, hexCode with Alpha: #FF242424
Color toColor(String colorToken) {
  var hexValue = ConfigResolver().getColorValue(colorToken);

  return hexToColor(hexValue ?? colorToken);
}

Color hexToColor(String colorHexString) {
  if (!isValidHexCode(colorHexString)) {
    // TODO: Instead of throwing, log error and provide fallback color
    throw FormatException(
        'Hexadecimal Color Value Is Invalid: $colorHexString');
  }

  var rgbString = colorHexString.replaceAll('#', '');

  if (colorHexString.length == 8) {
    return Color(int.parse('0x$rgbString'));
  }

  return Color(int.parse('0xFF$rgbString'));
}

bool isValidHexCode(String colorToken) {
  const validHexRegExp = r'^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$';

  return RegExp(validHexRegExp).hasMatch(colorToken);
}

double resolveSpacing(String spacingToken) {
  return ConfigResolver().getSpacing(spacingToken) ?? 0.0;
}

EdgeInsetsGeometry toEdgeInsetsGeometry(DUIInsets? insets) {
  if (insets == null) {
    return EdgeInsets.zero;
  }

  double parseInsetValue(String insetToken) {
    try {
      return double.parse(insetToken);
    } catch (e) {
      return ConfigResolver().getSpacing(insetToken) ?? 0.0;
    }
  }

  return EdgeInsets.fromLTRB(
      parseInsetValue(insets.left),
      parseInsetValue(insets.top),
      parseInsetValue(insets.right),
      parseInsetValue(insets.bottom));
}
