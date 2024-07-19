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
    final height = eval<double>(data.props['height'], context: context);
    final width = eval<double>(data.props['width'], context: context);
    final verticalAlign = toVerticalAlign(
        eval<String>(data.props['verticalAlign'], context: context));
    final alignment = DUIDecoder.toAlignment(
        eval<String>(data.props['alignment'], context: context));
    final maxLines = eval<int>(data.props['maxLines'], context: context);
    final textOverflow = DUIDecoder.toTextOverflow(
        eval<String>(data.props['textOverflow'], context: context));

    final googleFont = (data.props['fontFamily'] as String?)?.let(
      (p0) => GoogleFonts.getFont(p0,
          fontSize: eval<double>(data.props['fontSize'], context: context),
          fontStyle: DUIDecoder.toFontStyle(
              eval<String>(data.props['fontStyle'], context: context)),
          fontWeight: DUIDecoder.toFontWeight(
              eval<String>(data.props['fontWeight'], context: context)),
          height: eval<double>(data.props['lineHeight'], context: context),
          backgroundColor: makeColor(
              eval<String>(data.props['backgroundColor'], context: context)),
          color: makeColor(eval<String>(data.props['color'], context: context)),
          decoration: DUIDecoder.toTextDecoration(
              eval<String>(data.props['textDecoration'], context: context)),
          decorationColor: makeColor(eval<String>(
              data.props['textDecorationColor'],
              context: context)),
          decorationStyle: DUIDecoder.toTextDecorationStyle(eval<String>(
              data.props['textDecorationStyle'],
              context: context)),
          decorationThickness: eval<double>(data.props['textDecorationThickness'], context: context)),
    );

    Style makeStyle() {
      final style = Style(
          height: height != null ? Height(height) : null,
          width: width != null ? Width(width) : null,
          verticalAlign: verticalAlign,
          alignment: alignment,
          maxLines: maxLines,
          textOverflow: textOverflow);

      if (googleFont == null) return style;

      return style.merge(Style.fromTextStyle(googleFont));
    }

    return Html(
      data: eval<String>(data.props['content'], context: context),
      shrinkWrap:
          eval<bool>(data.props['shrinkWrap'], context: context) ?? false,
      style: {
        'b': makeStyle(),
        'span': makeStyle(),
        'sup': makeStyle(),
        'p': makeStyle(),
      },
    );
  }
}

VerticalAlign toVerticalAlign(String? value) {
  if (value == null) return VerticalAlign.baseline;

  return switch (value) {
    'baseline' => VerticalAlign.baseline,
    'sub' => VerticalAlign.sub,
    'sup' => VerticalAlign.sup,
    'top' => VerticalAlign.top,
    'bottom' => VerticalAlign.bottom,
    'middle' => VerticalAlign.middle,
    _ => VerticalAlign.baseline
  };
}
