import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWHtmlView extends VirtualLeafStatelessWidget {
  VWHtmlView({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    return Html(
      data: payload.eval<String>(props.get('content')),
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
  final textOverflow = DUIDecoder.toTextOverflow(
      payload.eval<String>(styleMap.get('textOverflow')));

  final googleFont = (styleMap.get('fontFamily') as String?)?.let(
    (p0) => GoogleFonts.getFont(p0,
        fontSize: payload.eval<double>(styleMap.get('fontSize')),
        fontStyle: DUIDecoder.toFontStyle(
            payload.eval<String>(styleMap.get('fontStyle'))),
        fontWeight: DUIDecoder.toFontWeight(
            payload.eval<String>(styleMap.get('fontWeight'))),
        height: payload.eval<double>(styleMap.get('lineHeight')),
        backgroundColor:
            makeColor(payload.eval<String>(styleMap.get('backgroundColor'))),
        color: makeColor(payload.eval<String>(styleMap.get('color'))),
        decoration: DUIDecoder.toTextDecoration(
            payload.eval<String>(styleMap.get('textDecoration'))),
        decorationColor: makeColor(
            payload.eval<String>(styleMap.get('textDecorationColor'))),
        decorationStyle: DUIDecoder.toTextDecorationStyle(
            payload.eval<String>(styleMap.get('textDecorationStyle'))),
        decorationThickness:
            payload.eval<double>(styleMap.get('textDecorationThickness'))),
  );

  final style = Style(maxLines: maxLines, textOverflow: textOverflow);

  if (googleFont == null) return style;

  return style.merge(Style.fromTextStyle(googleFont));
}
