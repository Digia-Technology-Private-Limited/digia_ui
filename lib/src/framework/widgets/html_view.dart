import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';

class VWHtmlView extends VirtualLeafStatelessWidget<Props> {
  VWHtmlView({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    String defaultData = '';
    if (props.isEmpty) {
      defaultData = ('<h1>H1 Header</h1> <h2>H2 Header</h2> <p>Paragraph</p>');
    }
    return Html(
      data: payload.eval<String>(props.get('content')) ?? defaultData,
      shrinkWrap: payload.eval<bool>(props.get('shrinkWrap')) ?? false,
      style: {
        'body': Style(padding: HtmlPaddings.all(0.0), margin: Margins.all(0.0))
            .merge(_makeStyle(payload,
                props.toProps('htmlStyleOverridesBody') ?? Props.empty())),
        'span': _makeStyle(
            payload, props.toProps('htmlStyleOverridesSpan') ?? Props.empty()),
        'p': _makeStyle(payload,
            props.toProps('htmlStyleOverridesParagraph') ?? Props.empty()),
      },
    );
  }
}

Style _makeStyle(RenderPayload payload, Props styleMap) {
  if (styleMap.isEmpty) return Style();

  final maxLines = payload.eval<int>(styleMap.get('maxLines'));
  final textOverflow =
      To.textOverflow(payload.eval<String>(styleMap.get('textOverflow')));
  final fontSize = payload.eval<double>(styleMap.get('fontSize'));
  final fontStyle =
      To.fontStyle(payload.eval<String>(styleMap.get('fontStyle')));
  final fontWeight =
      To.fontWeight(payload.eval<String>(styleMap.get('fontWeight')));
  final height = payload.eval<double>(styleMap.get('lineHeight'));
  final backgroundColor = payload.evalColor(styleMap.get('backgroundColor'));
  final color = payload.evalColor(styleMap.get('color'));
  final decoration =
      To.textDecoration(payload.eval<String>(styleMap.get('textDecoration')));
  final decorationColor =
      payload.evalColor(styleMap.get('textDecorationColor'));
  final decorationStyle = To.textDecorationStyle(
      payload.eval<String>(styleMap.get('textDecorationStyle')));
  final decorationThickness =
      payload.eval<double>(styleMap.get('textDecorationThickness'));

  final googleFont = (styleMap.getString('fontFamily')).maybe((p0) {
    if (styleMap.getString('fontFamily')!.isEmpty) {
      return null;
    }
    return GoogleFonts.getFont(
      p0,
      fontSize: fontSize,
      height: height,
    );
  });

  final style = Style(
    maxLines: maxLines,
    textOverflow: textOverflow,
    fontStyle: fontStyle,
    fontWeight: fontWeight,
    backgroundColor: backgroundColor,
    color: color,
    textDecoration: decoration,
    textDecorationColor: decorationColor,
    textDecorationStyle: decorationStyle,
    textDecorationThickness: decorationThickness,
  );

  if (googleFont == null) return style;

  return style.merge(Style.fromTextStyle(googleFont));
}
