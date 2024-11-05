import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';

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
  final textOverflow =
      To.textOverflow(payload.eval<String>(styleMap.get('textOverflow')));

  final googleFont = (styleMap.getString('fontFamily')).maybe(
    (p0) => payload.getFontFactory()?.getFont(p0,
        fontSize: payload.eval<double>(styleMap.get('fontSize')),
        fontStyle:
            To.fontStyle(payload.eval<String>(styleMap.get('fontStyle'))),
        fontWeight:
            To.fontWeight(payload.eval<String>(styleMap.get('fontWeight'))),
        height: payload.eval<double>(styleMap.get('lineHeight')),
        backgroundColor: payload.evalColor(styleMap.get('backgroundColor')),
        color: payload.evalColor(styleMap.get('color')),
        decoration: To.textDecoration(
            payload.eval<String>(styleMap.get('textDecoration'))),
        decorationColor: payload.evalColor(styleMap.get('textDecorationColor')),
        decorationStyle: To.textDecorationStyle(
            payload.eval<String>(styleMap.get('textDecorationStyle'))),
        decorationThickness:
            payload.eval<double>(styleMap.get('textDecorationThickness'))),
  );

  final style = Style(maxLines: maxLines, textOverflow: textOverflow);

  if (googleFont == null) return style;

  return style.merge(Style.fromTextStyle(googleFont));
}
