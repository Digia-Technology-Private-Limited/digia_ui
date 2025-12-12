import 'package:flutter/widgets.dart';

import '../font_factory.dart';
import '../resource_provider.dart';
import 'flutter_type_converters.dart';
import 'functional_util.dart';
import 'json_util.dart';
import 'num_util.dart';
import 'types.dart';

const defaultTextStyle = TextStyle(
  fontSize: 14,
  height: 1.5,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.normal,
);

TextStyle? makeTextStyle(
  JsonLike? json, {
  required BuildContext context,
  required T? Function<T extends Object>(Object?) eval,
  TextStyle? fallback = defaultTextStyle,
}) {
  if (json == null) return null;

  Color? evalColor(Object? expr) {
    return eval<String>(expr).maybe(
      (it) => ResourceProvider.maybeOf(context)?.getColor(it, context),
    );
  }

  final textColor = evalColor(json['textColor']);
  final textBgColor =
      evalColor(tryKeys<String>(json, ['textBackgroundColor', 'textBgColor']));
  final textDecoration = To.textDecoration(json['textDecoration']);
  final textDecorationColor = evalColor(json['textDecorationColor']);
  final textDecorationStyle =
      To.textDecorationStyle(json['textDecorationStyle']);

  var fontToken = json['fontToken'];

  // Case 1: No fontToken at all - use fallback with text decorations only
  if (fontToken == null) {
    return fallback?.copyWith(
      color: textColor,
      backgroundColor: textBgColor,
      decoration: textDecoration,
      decorationColor: textDecorationColor,
      decorationStyle: textDecorationStyle,
    );
  }

  // Case 2: fontToken is a string token reference - use token as-is
  if (fontToken is String) {
    final textStyle =
        ResourceProvider.maybeOf(context)?.getFontFromToken(fontToken);

    return (textStyle ?? defaultTextStyle).copyWith(
      color: textColor,
      backgroundColor: textBgColor,
      decoration: textDecoration,
      decorationColor: textDecorationColor,
      decorationStyle: textDecorationStyle,
    );
  }

  // Case 3: fontToken is a map
  fontToken = fontToken as JsonLike;

  final fontTokenValue = as$<String>(fontToken['value']);

  // Extract font property overrides
  final overridingFontFamily = fontToken.valueFor('font.fontFamily') as String?;
  final styleValue = fontToken.valueFor('font.style');
  final isItalicValue = fontToken.valueFor('font.isItalic');
  final overridingFontStyle = styleValue != null
      ? eval<String>(styleValue).maybe(To.fontStyle)
      : eval<bool>(isItalicValue).maybe((it) => it ? FontStyle.italic : null);
  final overridingFontWeight =
      eval<String>(fontToken.valueFor('font.weight')).maybe(To.fontWeight);
  final overridingFontSize = eval<double>(fontToken.valueFor('font.size'));
  final overridingFontHeight = eval<double>(fontToken.valueFor('font.height'));

  // Case 3a: Design/custom token is selected (has value key)
  // Use token as-is, ignore all font property overrides
  if (fontTokenValue != null) {
    final fontFromToken =
        ResourceProvider.maybeOf(context)?.getFontFromToken(fontTokenValue);

    // If token found, use it without overrides (only apply text decorations)
    if (fontFromToken != null) {
      return fontFromToken.copyWith(
        color: textColor,
        backgroundColor: textBgColor,
        decoration: textDecoration,
        decorationColor: textDecorationColor,
        decorationStyle: textDecorationStyle,
      );
    }

    // Token not found - fallback to default with overrides for backwards compatibility
    return defaultTextStyle.copyWith(
      fontWeight: overridingFontWeight,
      fontStyle: overridingFontStyle,
      fontSize: overridingFontSize,
      height: overridingFontHeight,
      color: textColor,
      backgroundColor: textBgColor,
      decoration: textDecoration,
      decorationColor: textDecorationColor,
      decorationStyle: textDecorationStyle,
    );
  }

  // Case 3b: No token value provided - use font property overrides
  // This allows custom inline font properties without referencing a token
  final textStyle = defaultTextStyle.copyWith(
    fontWeight: overridingFontWeight,
    fontStyle: overridingFontStyle,
    fontSize: overridingFontSize,
    height: overridingFontHeight,
    color: textColor,
    backgroundColor: textBgColor,
    decoration: textDecoration,
    decorationColor: textDecorationColor,
    decorationStyle: textDecorationStyle,
  );

  // Apply custom font family if specified
  final fontFactory = ResourceProvider.maybeOf(context)?.getFontFactory();
  if (overridingFontFamily == null || fontFactory == null) {
    return textStyle;
  }

  return fontFactory.getFont(overridingFontFamily, textStyle: textStyle);
}

TextStyle? convertToTextStyle(
  Object? value,
  DUIFontFactory? fontFactory,
) {
  if (value == null || value is! JsonLike) return null;

  FontWeight fontWeight = To.fontWeight(value['weight']);
  FontStyle fontStyle = To.fontStyle(value['style']);
  double fontSize = NumUtil.toDouble(value['size']) ?? 14;
  double fontHeight = NumUtil.toDouble(value['height']) ?? 1.5;
  // Below is done purposely. tryKeys doesn't check the type before casting.
  // Hence moved casting outside of tryKeys.
  String? fontFamily =
      as$<String>(tryKeys(value, ['font-family', 'fontFamily']));

  if (fontFactory != null && fontFamily != null) {
    return fontFactory.getFont(
      fontFamily,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
      height: fontHeight,
    );
  }

  return TextStyle(
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    fontSize: fontSize,
    height: fontHeight,
  );
}
