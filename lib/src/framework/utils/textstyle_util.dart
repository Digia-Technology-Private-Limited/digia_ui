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
      (it) => ResourceProvider.maybeOf(context)?.getColor(it),
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

  if (fontToken == null) {
    return fallback?.copyWith(
      color: textColor,
      backgroundColor: textBgColor,
      decoration: textDecoration,
      decorationColor: textDecorationColor,
      decorationStyle: textDecorationStyle,
    );
  }

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

  // This means json['fontToken'] is a map
  fontToken = fontToken as JsonLike;

  final fontTokenValue = as$<String>(fontToken['value']);
  final overridingFontFamily = fontToken.valueFor('font.fontFamily') as String?;
  final overridingFontStyle =
      eval<String>(fontToken.valueFor('font.style')).maybe(To.fontStyle);
  final overridingFontWeight =
      eval<String>(fontToken.valueFor('font.weight')).maybe(To.fontWeight);
  final overridingFontSize = eval<double>(fontToken.valueFor('font.size'));
  final overridingFontHeight = eval<double>(fontToken.valueFor('font.height'));

  final fontFromToken = fontTokenValue
      .maybe((it) => ResourceProvider.maybeOf(context)?.getFontFromToken(it));

  final textStyle = (fontFromToken ?? defaultTextStyle).copyWith(
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
