import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';

class DUIHtmlViewBuilder extends DUIWidgetBuilder {
  DUIHtmlViewBuilder({required super.data});

  static DUIHtmlViewBuilder? create(DUIWidgetJsonData data) {
    return DUIHtmlViewBuilder(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return Html(
      data: eval<String>(data.props['content'], context: context),
      shrinkWrap:
          eval<bool>(data.props['shrinkWrap'], context: context) ?? false,
      style: {
        'body': Style(padding: HtmlPaddings.all(0.0), margin: Margins.all(0.0))
            .merge(_makeStyle(context, data.props['htmlStyleOverridesBody'])),
        'span': _makeStyle(context, data.props['htmlStyleOverridesSpan']),
        'p': _makeStyle(context, data.props['htmlStyleOverridesParagraph']),
      },
    );
  }
}

Style _makeStyle(BuildContext context, Object? styleMap) {
  if (styleMap == null) return Style();
  if (styleMap is! Map<String, dynamic>) return Style();

  final maxLines = eval<int>(styleMap['maxLines'], context: context);
  final textOverflow = DUIDecoder.toTextOverflow(
      eval<String>(styleMap['textOverflow'], context: context));

  final googleFont = (styleMap['fontFamily'] as String?)?.let(
    (p0) => GoogleFonts.getFont(p0,
        fontSize: eval<double>(styleMap['fontSize'], context: context),
        fontStyle: DUIDecoder.toFontStyle(
            eval<String>(styleMap['fontStyle'], context: context)),
        fontWeight: DUIDecoder.toFontWeight(
            eval<String>(styleMap['fontWeight'], context: context)),
        height: eval<double>(styleMap['lineHeight'], context: context),
        backgroundColor: makeColor(
            eval<String>(styleMap['backgroundColor'], context: context)),
        color: makeColor(eval<String>(styleMap['color'], context: context)),
        decoration: DUIDecoder.toTextDecoration(
            eval<String>(styleMap['textDecoration'], context: context)),
        decorationColor: makeColor(
            eval<String>(styleMap['textDecorationColor'], context: context)),
        decorationStyle: DUIDecoder.toTextDecorationStyle(
            eval<String>(styleMap['textDecorationStyle'], context: context)),
        decorationThickness: eval<double>(styleMap['textDecorationThickness'],
            context: context)),
  );

  final style = Style(maxLines: maxLines, textOverflow: textOverflow);

  if (googleFont == null) return style;

  return style.merge(Style.fromTextStyle(googleFont));
}
