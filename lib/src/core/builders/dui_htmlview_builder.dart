import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
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
    final backgroundColor = makeColor(
        eval<String>(data.props['backgroundColor'], context: context));
    final color =
        makeColor(eval<String>(data.props['color'], context: context));
    final fontFamily = eval<String>(data.props['fontFamily'], context: context);
    final fontSize = eval<double>(data.props['fontSize'], context: context);
    final fontStyle = eval<String>(data.props['fontStyle'], context: context);
    final fontWeight = DUIDecoder.toFontWeight(
        eval<String>(data.props['fontWeight'], context: context));
    final height = eval<double>(data.props['height'], context: context);
    final width = eval<double>(data.props['width'], context: context);
    final lineHeight = eval<double>(data.props['lineHeight'], context: context);
    final textAlign = DUIDecoder.toTextAlign(
        eval<String>(data.props['textAlign'], context: context));
    final textDecoration = DUIDecoder.toTextDecoration(
        eval<String>(data.props['textDecoration'], context: context));
    final textDecorationColor = makeColor(
        eval<String>(data.props['textDecorationColor'], context: context));
    final textDecorationStyle = DUIDecoder.toTextDecorationStyle(
        eval<String>(data.props['textDecorationStyle'], context: context));
    final textDecorationThickness =
        eval<double>(data.props['textDecorationThickness'], context: context);
    final verticalAlign = toVerticalAlign(
        eval<String>(data.props['verticalAlign'], context: context));
    final alignment = DUIDecoder.toAlignment(
        eval<String>(data.props['alignment'], context: context));
    final maxLines = eval<int>(data.props['maxLines'], context: context);
    final textOverflow = DUIDecoder.toTextOverflow(
        eval<String>(data.props['textOverflow'], context: context));

    Style makeStyle() {
      return Style(
        backgroundColor: backgroundColor,
        color: color,
        fontFamily: fontFamily,
        fontSize: fontSize != null ? FontSize(fontSize) : FontSize.medium,
        fontStyle: fontStyle == 'italic' ? FontStyle.italic : FontStyle.normal,
        fontWeight: fontWeight,
        height: height != null ? Height(height) : null,
        width: width != null ? Width(width) : null,
        lineHeight: LineHeight(lineHeight),
        textAlign: textAlign,
        textDecoration: textDecoration,
        textDecorationColor: textDecorationColor,
        textDecorationStyle: textDecorationStyle,
        textDecorationThickness: textDecorationThickness,
        verticalAlign: verticalAlign,
        alignment: alignment,
        maxLines: maxLines,
        textOverflow: textOverflow,
      );
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
