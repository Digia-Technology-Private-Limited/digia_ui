import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../page/resource_provider.dart';
import 'flutter_type_converters.dart';
import 'functional_util.dart';
import 'json_util.dart';
import 'num_util.dart';
import 'types.dart';

final _defaultTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  height: 1.5,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.normal,
);

TextStyle? makeTextStyle(
  JsonLike? json, {
  required BuildContext context,
  required T? Function<T extends Object>(Object?) eval,
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

  final fontToken =
      as$<String>(json['fontToken'] ?? json.valueFor('fontToken.value'));

  if (fontToken == null) {
    return _defaultTextStyle.copyWith(
      color: textColor,
      backgroundColor: textBgColor,
      decoration: textDecoration,
      decorationColor: textDecorationColor,
      decorationStyle: textDecorationStyle,
    );
  }

  if (json['fontToken'] is String) {
    final textStyle =
        ResourceProvider.maybeOf(context)?.getTextStyle(fontToken);

    return (textStyle ?? _defaultTextStyle).copyWith(
      color: textColor,
      backgroundColor: textBgColor,
      decoration: textDecoration,
      decorationColor: textDecorationColor,
      decorationStyle: textDecorationStyle,
    );
  }

  // This means json['fontToken'] is a map
  final textStyle = ResourceProvider.maybeOf(context)?.getTextStyle(fontToken);
  final fontFamily = json.valueFor('fontToken.font.fontFamily') as String? ??
      textStyle?.fontFamily ??
      _defaultTextStyle.fontFamily!;
  final fontWeight = eval<String>(json.valueFor('fontToken.font.weight'))
          .maybe(To.fontWeight) ??
      textStyle?.fontWeight ??
      _defaultTextStyle.fontWeight;
  final fontStyle =
      eval<String>(json.valueFor('fontToken.font.style')).maybe(To.fontStyle) ??
          textStyle?.fontStyle ??
          _defaultTextStyle.fontStyle;
  final fontSize = eval<double>(json.valueFor('fontToken.font.size')) ??
      textStyle?.fontSize ??
      _defaultTextStyle.fontSize;
  final height = eval<double>(json.valueFor('fontToken.font.height')) ??
      textStyle?.height ??
      _defaultTextStyle.height;
  return GoogleFonts.getFont(
    fontFamily,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    fontSize: fontSize,
    height: height,
    color: textColor,
    backgroundColor: textBgColor,
    decoration: textDecoration,
    decorationColor: textDecorationColor,
    decorationStyle: textDecorationStyle,
  );
}

TextStyle? convertToTextStyle(dynamic value) {
  if (value == null || value is! JsonLike) return null;

  FontWeight fontWeight = To.fontWeight(value['weight']);
  FontStyle fontStyle = To.fontStyle(value['style']);
  double fontSize = NumUtil.toDouble(value['size']) ?? 14;
  double fontHeight = NumUtil.toDouble(value['height']) ?? 1.5;
  // Below is done purposely. tryKeys doesn't check the type before casting.
  // Hence moved casting outside of tryKeys.
  String fontFamily =
      as$<String>(tryKeys(value, ['font-family', 'fontFamily'])) ?? 'Poppins';

  return GoogleFonts.getFont(
    fontFamily,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    fontSize: fontSize,
    height: fontHeight,
  );
}
