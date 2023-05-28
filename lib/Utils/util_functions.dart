import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/components/DUICard/dui_card.dart';
import 'package:digia_ui/components/DUIText/DUI_text_span/dui_text_span.dart';
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/components/button/button.dart';
import 'package:digia_ui/components/image/image.dart';
import 'package:digia_ui/components/techCard/tech_card.dart';
import 'package:digia_ui/components/utils/DUICornerRadius/dui_corner_radius.dart';
import 'package:digia_ui/components/utils/DUIInsets/dui_insets.dart';
import 'package:digia_ui/core/grid/dui_grid_view.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
final Map<String, Function> DUIWidgetRegistry = {
  // 'digia/button': DUIButton.fromJson,
  'digia/text': DUIText.create,
  'digia/image': DUIImage.create,
  'digia/button': DUIButton.create,
  'digia/card_type1': DUITechCard.create,
  'digia/card_type2': DUICard.create,
  'digia/grid': DUIGridView.create
};

class DUIConfigConstants {
  static const double fallbackSize = 14;
  static const String fallbackStyle = "";
  static const Color fallbackTextColor = Colors.black;
  static const double fallbackLineHeightFactor = 1.5;
  static const String fallbackBgColorHexCode = "#FFFFFF";
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
    case "ellipsis":
      return TextOverflow.ellipsis;
  }

  return TextOverflow.clip;
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

TextStyle? toTextStyle(String? styleClass) {
  var styleClassMap = createStyleMap(styleClass);

  if (styleClassMap.isEmpty) {
    return null;
  }

  FontWeight fontWeight = FontWeight.normal;
  FontStyle fontStyle = FontStyle.normal;
  double fontSize = DUIConfigConstants.fallbackSize;
  double fontHeight = DUIConfigConstants.fallbackLineHeightFactor;
  Color textColor = DUIConfigConstants.fallbackTextColor;
  Color? textBgColor;
  TextDecoration textDecoration = TextDecoration.none;
  Color? decorationColor;
  TextDecorationStyle? decorationStyle;
  String fontFamily = "Poppins"; // TODO: This shouldn't be hardcoded here.

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

      // Font family
      case 'ff':
        fontFamily = value;
        break;

      // Text Color
      case 'tc':
        textColor = toColor(value);
        break;

      // Text Background Color
      case 'tbc':
        textBgColor = toColor(value);
        break;

      // Text Decoration
      case 'td':
        textDecoration = toTextDecoration(value);
        break;

      // Text Deocration Color
      case 'tdc':
        decorationColor = toColor(value);
        break;

      // Text Deocration Style
      case 'tds':
        decorationStyle = toTextDecorationStyle(value);
    }
  });

  return TextStyle(
      fontFamily: fontFamily,
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

TextSpan toTextSpan(DUITextSpan textSpan) {
  return TextSpan(
    text: textSpan.text,
    style: toTextStyle(textSpan.styleClass ?? ""),
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

BorderRadiusGeometry toBorderRadiusGeometry(DUICornerRadius? cornerRadius) {
  if (cornerRadius == null) {
    return BorderRadius.zero;
  }

  return BorderRadius.only(
    topLeft: Radius.circular(cornerRadius.topLeft),
    topRight: Radius.circular(cornerRadius.topRight),
    bottomLeft: Radius.circular(cornerRadius.bottomLeft),
    bottomRight: Radius.circular(cornerRadius.bottomRight),
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

double _parseSpacingToken(String token) {
  try {
    return double.parse(token);
  } catch (e) {
    return ConfigResolver().getSpacing(token) ?? 0.0;
  }
}

double resolveSpacing(String? spacingToken) {
  if (spacingToken == null || spacingToken.isEmpty) return 0;

  return _parseSpacingToken(spacingToken);
}

EdgeInsetsGeometry toEdgeInsetsGeometry(DUIInsets? insets) {
  if (insets == null) {
    return EdgeInsets.zero;
  }

  return EdgeInsets.fromLTRB(
      _parseSpacingToken(insets.left),
      _parseSpacingToken(insets.top),
      _parseSpacingToken(insets.right),
      _parseSpacingToken(insets.bottom));
}

AlignmentGeometry? toAlignmentGeometry(String? token) {
  if (token == null) {
    return null;
  }

  switch (token) {
    case 'topLeft':
      return Alignment.topLeft;

    case 'topCenter':
      return Alignment.topCenter;

    case 'topRight':
      return Alignment.topRight;

    case 'centerLeft':
      return Alignment.centerLeft;

    case 'center':
      return Alignment.center;

    case 'centerRight':
      return Alignment.centerRight;

    case 'bottomLeft':
      return Alignment.bottomLeft;

    case 'bottomCenter':
      return Alignment.bottomCenter;

    case 'bottomRight':
      return Alignment.bottomRight;
  }

  return null;
}
