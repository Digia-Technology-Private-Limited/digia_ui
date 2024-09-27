import 'dart:math';

import 'package:flutter/material.dart';

class ColorUtil {
  /// Regular expression pattern to validate hex color strings.
  ///
  /// The pattern checks for valid hex color strings in the following formats:
  /// - "#RGB" or "#RRGGBB" (with or without the leading "#").
  /// - "#RGBA" or "#RRGGBBAA" (with or without the leading "#").
  ///
  /// The `R`, `G`, `B`, and `A` represent hexadecimal digits (0-9, A-F, a-f) that
  /// define the red, green, blue, and alpha components of the color, respectively.
  ///
  /// If the alpha value is not provided, the pattern assumes it to be 255 (fully opaque).
  /// The alpha value can be either a double ranging from 0.0 to 1.0, or a hexadecimal value
  /// ranging from 00 to FF (0 to 255 in decimal).
  static RegExp hexColorPattern =
      RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$');

  /// Checks if a given hex color string is a valid color value.
  ///
  /// Example valid hex color strings:
  /// - "#FF0000" (red color)
  /// - "00FF00" (green color)
  /// - "#12345F80" (blue color with alpha value of 128)
  ///
  /// Parameters:
  /// - [hex]: The hex color string to be validated.
  ///
  /// Returns:
  /// - `true` if the hex string is a valid color value, otherwise `false`.
  static bool isValidColorHex(String hex) {
    return hexColorPattern.hasMatch(hex);
  }

  ///
  /// Converts the given [hex] color string to the corresponding int.
  ///
  /// Note that when no alpha/opacity is specified, 0xFF is assumed.
  ///
  static int hexToInt(String hex) {
    final hexDigits = hex.startsWith('#') ? hex.substring(1) : hex;
    final hexMask = hexDigits.length <= 6 ? 0xFF000000 : 0;
    final hexValue = int.parse(hexDigits, radix: 16);
    assert(hexValue >= 0 && hexValue <= 0xFFFFFFFF);
    return hexValue | hexMask;
  }

  ///
  /// Converts the given [hex] color string to [Color] Object.
  ///
  /// Returns null, if hex isn't valid.
  ///
  static Color fromHexString(String hex) {
    final hexIntValue = hexToInt(hex);
    return Color(hexIntValue);
  }

  static Color? tryFromHexString(String hex) {
    try {
      return fromHexString(hex);
    } catch (e, _) {
      return null;
    }
  }

  /// Tries to create a color from comma-separated red, green, blue, and opacity values
  /// in String.
  ///
  /// * 1st position is [red], from 0 to 255.
  /// * 2nd position is [green], from 0 to 255.
  /// * 3rd position is [blue], from 0 to 255.
  /// * 4th position (optional) is `opacity`.
  ///   Two formats are accepted.
  ///   * Double: 0.0 being transparent, 1.0 being fully opaque.
  ///   * Hex: 0 being transparent, 255 being full opaque.
  ///
  /// Out of range values are brought into range using modulo operator.
  ///
  static Color fromRgbaString(String rgba) {
    // Extract the individual components
    List<String> components = rgba.split(',');

    // Invalid format, return null
    if (components.length < 3) {
      throw 'Invalid RGBA format';
    }

    // Extract R,G,B,A and ensure that the values are within the valid range
    int r = int.parse(components[0]).clamp(0, 255);
    int g = int.parse(components[1]).clamp(0, 255);
    int b = int.parse(components[2]).clamp(0, 255);
    double a = 1.0;
    if (components.length == 4) {
      final alpha_0_255 = int.tryParse(components[3]);
      if (alpha_0_255 != null) {
        a = (alpha_0_255.clamp(0, 255)) / 255.0;
      } else {
        a = double.tryParse(components[3])?.clamp(0.0, 1.0) ?? 1.0;
      }
    }

    return Color.fromRGBO(r, g, b, a);
  }

  static Color? tryFromRgbaString(String hex) {
    try {
      return fromRgbaString(hex);
    } catch (e, _) {
      return null;
    }
  }

  ///
  /// Tries to convert a string value to Color Object.
  ///
  static Color? fromString(String? value) {
    if (value == null) return null;

    if (value.isEmpty) return null;

    return tryFromHexString(value) ?? tryFromRgbaString(value);
  }

  ///
  /// Converts a string value to Color Object.
  ///
  /// Accepts fallback color when string parsing fails.
  ///
  static Color fromStringOrDefault(String value,
      {Color defaultColor = Colors.transparent}) {
    return fromString(value) ?? defaultColor;
  }

  ///
  /// Converts the given integer [i] to a hex string with a leading #.
  ///
  /// Note that only the RGB values will be returned (like #RRGGBB), so
  /// and alpha/opacity value will be stripped.
  ///
  static String intToHex(int i) {
    assert(i >= 0 && i <= 0xFFFFFFFF);
    return '#${(i & 0xFFFFFF | 0x1000000).toRadixString(16).substring(1).toUpperCase()}';
  }

  ///
  /// Fills up the given 3 char [hex] string to 6 char hex string.
  ///
  /// Will add a # to the [hex] string if it is missing.
  ///
  static String fillUpHex(String hex) {
    if (!hex.startsWith('#')) {
      hex = '#$hex';
    }

    if (hex.length == 7) {
      return hex;
    }

    var filledUp = '';
    for (var r in hex.runes) {
      var char = String.fromCharCode(r);
      if (char == '#') {
        filledUp = filledUp + char;
      } else {
        filledUp = filledUp + char + char;
      }
    }
    return filledUp;
  }

  /// Converts `dart:ui` [Color] to the 6/8 digits HEX [String].
  ///
  /// Prefixes a hash (`#`) sign if [includeHashSign] is set to `true`.
  /// The result will be provided as UPPER CASE, it can be changed via [toUpperCase]
  /// flag set to `false` (default is `true`). Hex can be returned without alpha
  /// channel information (transparency), with the [enableAlpha] flag set to `false`.
  static String toHexString(Color color,
      {bool includeHashSign = true, bool skipAlphaIfOpaque = true}) {
    final alphaString =
        (skipAlphaIfOpaque && _padRadix(color.alpha).toUpperCase() == 'FF')
            ? ''
            : _padRadix(color.alpha);
    final String hex = (includeHashSign ? '#' : '') +
        alphaString +
        _padRadix(color.red) +
        _padRadix(color.green) +
        _padRadix(color.blue);
    return hex.toUpperCase();
  }

// Shorthand for padLeft of RadixString, DRY.
  static String _padRadix(int value) => value.toRadixString(16).padLeft(2, '0');

  static Color randomColor({double opacity = 0.3}) =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(opacity);
}
